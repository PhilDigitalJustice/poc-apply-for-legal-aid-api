package uk.gov.laa.apply.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "applicants")
public class Applicant {

  @Id
  @GeneratedValue
  private UUID id;

  private String firstName;
  private String lastName;

  @Column(name = "date_of_birth")
  private LocalDate dateOfBirth;


}

