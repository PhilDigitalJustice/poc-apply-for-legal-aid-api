package uk.gov.laa.apply.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.UUID;
import lombok.Data;

@Entity
@Table(name = "providers")
@Data
public class Provider {

  @Id
  @GeneratedValue
  private UUID id;

  private String username;


}
