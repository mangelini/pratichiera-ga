package com.pratichiera.pratichieraga.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "price_lists")
public class PriceListEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "pl_seq")
    @SequenceGenerator(name = "pl_seq", sequenceName = "price_list_seq", allocationSize = 1)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "reference_month", nullable = false)
    private LocalDate referenceMonth;

    @Builder.Default
    private boolean closed = false;

    @ManyToMany
    @JoinTable(name = "price_list_users", joinColumns = @JoinColumn(name = "price_list_id"), inverseJoinColumns = @JoinColumn(name = "user_id"))
    @Builder.Default
    private Set<UserEntity> users = new HashSet<>();

    @OneToMany(mappedBy = "priceList", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PriceListItemEntity> items = new ArrayList<>();
}
