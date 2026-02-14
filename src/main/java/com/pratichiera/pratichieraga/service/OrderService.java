package com.pratichiera.pratichieraga.service;

import com.pratichiera.pratichieraga.model.OrderEntity;
import com.pratichiera.pratichieraga.model.OrderItemEntity;
import com.pratichiera.pratichieraga.model.PriceListEntity;
import com.pratichiera.pratichieraga.model.UserEntity;
import com.pratichiera.pratichieraga.repository.OrderItemRepository;
import com.pratichiera.pratichieraga.repository.OrderRepository;
import com.pratichiera.pratichieraga.repository.PriceListItemRepository;
import com.pratichiera.pratichieraga.repository.PriceListRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final PriceListRepository priceListRepository;
    private final PriceListItemRepository priceListItemRepository;
    private final EmailService emailService;

    public List<OrderEntity> getAllOrders() {
        return orderRepository.findAllByOrderByCreatedDateDesc();
    }

    @Transactional
    public void submitOrder(UserEntity user, PriceListEntity priceList, String fullName, String phoneNumber,
            String email) {
        OrderEntity order = OrderEntity.builder()
                .user(user)
                .fullName(fullName)
                .phoneNumber(phoneNumber)
                .email(email)
                .build();

        boolean hasItems = false;

        for (var plItem : priceList.getItems()) {
            if (plItem.getQuantity() != null && plItem.getQuantity() > 0) {
                OrderItemEntity orderItem = OrderItemEntity.builder()
                        .productName(plItem.getProductName())
                        .packaging(plItem.getPackaging())
                        .notes(plItem.getNotes())
                        .pricePerKg(plItem.getPricePerKg())
                        .quantity(plItem.getQuantity())
                        .build();

                order.addItem(orderItem);
                hasItems = true;

                plItem.setQuantity(0);
                priceListItemRepository.save(plItem);
            }
        }

        if (hasItems) {
            orderRepository.save(order);
            emailService.sendOrderConfirmation(order);
        }
    }
}
