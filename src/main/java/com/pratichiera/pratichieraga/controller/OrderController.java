package com.pratichiera.pratichieraga.controller;

import com.pratichiera.pratichieraga.model.*;
import com.pratichiera.pratichieraga.repository.*;
import com.pratichiera.pratichieraga.service.*;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/orders")
public class OrderController {

    private final PriceListRepository priceListRepository;
    private final PriceListItemRepository priceListItemRepository;
    private final OrderService orderService;

    @GetMapping
    public String viewCurrentOrder(HttpSession session, Model model) {
        UserEntity user = (UserEntity) session.getAttribute("currentUser");

        if (user == null) {
            return "redirect:/login";
        }

        LocalDate currentMonth = LocalDate.now().withDayOfMonth(1);

        PriceListEntity priceList = priceListRepository.findByUsersContainingAndReferenceMonth(user, currentMonth)
                .orElse(null);

        model.addAttribute("priceList", priceList);
        model.addAttribute("user", user);

        return "order/order_form";
    }

    @PostMapping("/submit")
    public String submitOrder(@RequestParam Map<String, String> params, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        LocalDate currentMonth = LocalDate.now().withDayOfMonth(1);
        PriceListEntity priceList = priceListRepository.findByUsersContainingAndReferenceMonth(user, currentMonth)
                .orElse(null);

        if (priceList == null) {
            return "redirect:/orders?error=no_pricelist";
        }

        // 1. Update quantities first
        params.forEach((key, value) -> {
            if (key.startsWith("qty_")) {
                Long itemId = Long.valueOf(key.substring(4));
                Integer quantity = Integer.valueOf(value);

                priceListItemRepository.findById(itemId).ifPresent(item -> {
                    // Security check: ensure item belongs to the current price list
                    if (item.getPriceList().getId().equals(priceList.getId())) {
                        item.setQuantity(quantity);
                        priceListItemRepository.save(item);
                    }
                });
            }
        });

        // 2. Submit order (Creates OrderEntity, Emails, Resets Quantities)
        String fullName = params.get("fullName");
        String phoneNumber = params.get("phoneNumber");
        String email = params.get("email");

        orderService.submitOrder(user, priceList, fullName, phoneNumber, email);

        return "redirect:/orders?success=true";
    }
}