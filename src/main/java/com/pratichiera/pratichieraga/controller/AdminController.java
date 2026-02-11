package com.pratichiera.pratichieraga.controller;

import com.pratichiera.pratichieraga.model.*;
import com.pratichiera.pratichieraga.repository.*;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final UserRepository userRepository;
    private final PriceListRepository priceListRepository;
    private final PriceListItemRepository priceListItemRepository;
    private final com.pratichiera.pratichieraga.service.OrderService orderService;

    @GetMapping
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";

        model.addAttribute("users", userRepository.findAll());
        model.addAttribute("priceLists", priceListRepository.findAll());
        return "admin/dashboard";
    }

    @GetMapping("/orders")
    public String listOrders(HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";

        model.addAttribute("orders", orderService.getAllOrders());
        return "admin/orders";
    }

    @PostMapping("/users")
    public String createUser(@RequestParam String username, @RequestParam String password) {
        UserEntity newUser = UserEntity.builder()
                .username(username)
                .password(password)
                .isAdmin(false)
                .build();
        userRepository.save(newUser);
        return "redirect:/admin";
    }

    @PostMapping("/pricelists")
    public String createPriceList(@RequestParam String name, @RequestParam String month, HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";

        // month param comes as "YYYY-MM"
        LocalDate date = LocalDate.parse(month + "-01", DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        PriceListEntity priceList = PriceListEntity.builder()
                .name(name)
                .referenceMonth(date)
                .build();

        priceListRepository.save(priceList);
        return "redirect:/admin/pricelists/" + priceList.getId();
    }

    @GetMapping("/pricelists/{id}")
    public String editPriceList(@PathVariable Long id, Model model, HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";

        PriceListEntity priceList = priceListRepository.findById(id).orElseThrow();
        model.addAttribute("priceList", priceList);
        model.addAttribute("allUsers", userRepository.findAll());
        return "admin/edit_pricelist";
    }

    @PostMapping("/pricelists/{id}/users/add")
    public String addUserToPriceList(@PathVariable Long id,
            @RequestParam Long userId,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";

        PriceListEntity priceList = priceListRepository.findById(id).orElseThrow();
        UserEntity user = userRepository.findById(userId).orElseThrow();
        priceList.getUsers().add(user);
        priceListRepository.save(priceList);

        return "redirect:/admin/pricelists/" + id;
    }

    @PostMapping("/pricelists/{id}/users/{userId}/remove")
    public String removeUserFromPriceList(@PathVariable Long id,
            @PathVariable Long userId,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";

        PriceListEntity priceList = priceListRepository.findById(id).orElseThrow();
        priceList.getUsers().removeIf(u -> u.getId().equals(userId));
        priceListRepository.save(priceList);

        return "redirect:/admin/pricelists/" + id;
    }

    @PostMapping("/pricelists/{id}/items")
    public String addItem(@PathVariable Long id,
            @RequestParam String productName,
            @RequestParam String packaging,
            @RequestParam BigDecimal price,
            @RequestParam(required = false) String notes) {

        PriceListEntity priceList = priceListRepository.findById(id).orElseThrow();

        PriceListItemEntity item = PriceListItemEntity.builder()
                .priceList(priceList)
                .productName(productName)
                .packaging(packaging)
                .pricePerKg(price)
                .notes(notes)
                .quantity(0)
                .build();

        priceListItemRepository.save(item);
        return "redirect:/admin/pricelists/" + id;
    }

    @PostMapping("/items/{id}/delete")
    public String deleteItem(@PathVariable Long id, HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";

        PriceListItemEntity item = priceListItemRepository.findById(id).orElseThrow();
        Long listId = item.getPriceList().getId();
        priceListItemRepository.delete(item);
        return "redirect:/admin/pricelists/" + listId;
    }

    @PostMapping("/pricelists/{id}/delete")
    public String deletePriceList(@PathVariable Long id, HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";

        PriceListEntity priceList = priceListRepository.findById(id).orElseThrow();
        priceListRepository.delete(priceList);
        return "redirect:/admin";
    }

    private boolean isAdmin(HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("currentUser");
        return user != null && user.getIsAdmin();
    }
}
