package com.pratichiera.pratichieraga.repository;

import com.pratichiera.pratichieraga.model.PriceListEntity;
import com.pratichiera.pratichieraga.model.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.Optional;

public interface PriceListRepository extends JpaRepository<PriceListEntity, Long> {
    Optional<PriceListEntity> findByUsersContainingAndReferenceMonth(UserEntity user, LocalDate referenceMonth);
}
