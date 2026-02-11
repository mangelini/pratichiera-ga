package com.pratichiera.pratichieraga.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "price_list_items")
public class PriceListItemEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "pli_seq")
    @SequenceGenerator(name = "pli_seq", sequenceName = "price_list_item_seq", allocationSize = 1)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "price_list_id", nullable = false)
    private PriceListEntity priceList;

    @Column(nullable = false)
    private String productName;

    private String packaging;

    private String notes;

    @Column(name = "price_per_kg", nullable = false)
    private BigDecimal pricePerKg;

    @Column(nullable = false)
    @Builder.Default
    private Integer quantity = 0;
}
