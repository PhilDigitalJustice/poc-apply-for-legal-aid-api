package uk.gov.laa.apply.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import lombok.Data;

@Entity
@Table(name = "offices")
@Data
public class Office {

  @Id
  @GeneratedValue
  private UUID id;

  @Column(name = "ccms_id")
  private String ccmsId;

  private String code;

  @ManyToOne
  @JoinColumn(name = "firm_id")
  private Firm firm;

  @ManyToMany
  @JoinTable(
      name = "offices_providers",
      joinColumns = @JoinColumn(name = "office_id"),
      inverseJoinColumns = @JoinColumn(name = "provider_id")
  )
  private List<Provider> providers;

  // Additional fields like createdAt and updatedAt
  @Column(name = "created_at", nullable = false)
  private LocalDateTime createdAt;

  @Column(name = "updated_at", nullable = false)
  private LocalDateTime updatedAt;

  // Getters and Setters
}

