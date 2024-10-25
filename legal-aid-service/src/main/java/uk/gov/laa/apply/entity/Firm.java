package uk.gov.laa.apply.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import lombok.Data;

@Entity
@Table(name = "firms")
@Data
public class Firm {

  @Id
  @GeneratedValue
  private UUID id;

  private String ccmsId;
  private String name;

  @OneToMany(mappedBy = "firm", cascade = CascadeType.ALL, orphanRemoval = true)
  private List<Office> offices;

  // Timestamps
  @Column(name = "created_at", nullable = false)
  private LocalDateTime createdAt;

  @Column(name = "updated_at", nullable = false)
  private LocalDateTime updatedAt;

}

