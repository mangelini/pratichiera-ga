package com.pratichiera.pratichieraga.repository;

import com.pratichiera.pratichieraga.model.UserEntity;
import org.springframework.data.repository.CrudRepository;

public interface UserRepository extends CrudRepository<UserEntity, Long> {
}
