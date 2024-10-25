package uk.gov.laa.apply.repository;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import uk.gov.laa.apply.entity.Application;

public interface ApplicationRepository extends JpaRepository<Application, UUID> {
}
