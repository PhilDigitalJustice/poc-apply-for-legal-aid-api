package uk.gov.laa.apply.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.UUID;
import lombok.Data;

@Entity
@Table(name = "proceedings")
@Data
public class Proceeding {

  @Id
  @GeneratedValue
  private UUID id;

  @ManyToOne
  @JoinColumn(name = "legal_aid_application_id", nullable = false)
  private Application application;

  @Column(name = "ccms_code", nullable = false)
  private String ccmsCode;

  private String meaning;
  private BigDecimal substantiveCostLimitation;

}

