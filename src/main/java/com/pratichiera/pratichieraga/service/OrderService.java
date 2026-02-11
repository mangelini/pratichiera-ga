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
    public void submitOrder(UserEntity user, PriceListEntity priceList) {
        // Create Order Structure
        OrderEntity order = OrderEntity.builder()
                .user(user)
                .build();

        // Find items in the price list that have quantity > 0
        // NOTE: The current data model (PriceListItemEntity) stores quantity directly
        // on the item.
        // This implies that PriceListItemEntity is essentially "CartItem" for a
        // SPECIFIC user if the PriceList was per-user?
        // Wait, looking at PriceListEntity: it has @ManyToMany users.
        // AND @OneToMany items.
        // If multiple users share the SAME PriceListEntity, they share the SAME
        // PriceListItemEntity rows?
        // IF SO, THEN UPDATING QUANTITY OVERWRITES EACH OTHER!
        // CHECKING PriceListItemEntity again...
        // It has `private Integer quantity = 0;`
        //
        // CRITICAL: If PriceList is shared (ManyToMany users), then PriceListItemEntity
        // is shared.
        // If User A sets quantity 5, User B sees quantity 5.
        // THIS IS A BUG IN THE PREVIOUS MODEL if the intention was for multiple users
        // to use the same price list simultaneously.
        //
        // HOWEVER, likely the previous pattern was: One PriceList per Session? Or maybe
        // it wasn't designed for multi-user yet?
        // Let's assume for this task we respect the user's "cart" which is currently
        // stored in PriceListItemEntity.
        // We will read those quantities, create the order, and then RESET them to 0.
        // This confirms the "Cart Behavior" discussed plan: "Reset quantities to 0".

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

                // Reset quantity in the "Cart"
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
