package uk.gov.laa.apply.entity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import lombok.Data;

@Entity
@Table(name = "legal_aid_applications")
@Data
public class Application {

  @Id
  @GeneratedValue
  private UUID id;

  @Column(name = "application_ref")
  private String applicationRef;

  @Column(name = "created_at", nullable = false)
  private LocalDateTime createdAt;

  @Column(name = "updated_at", nullable = false)
  private LocalDateTime updatedAt;

  @ManyToOne
  @JoinColumn(name = "applicant_id", nullable = false)
  private Applicant applicant;

  @ManyToOne
  @JoinColumn(name = "provider_id")
  private Provider provider;

  @ManyToOne
  @JoinColumn(name = "office_id")
  private Office office;

  @Column(name = "has_offline_accounts")
  private Boolean hasOfflineAccounts;

  @Column(name = "open_banking_consent")
  private Boolean openBankingConsent;

  @Column(name = "property_value", precision = 10, scale = 2)
  private BigDecimal propertyValue;

  @Column(name = "outstanding_mortgage_amount")
  private BigDecimal outstandingMortgageAmount;

  // List of proceedings for this application
  @OneToMany(mappedBy = "application", cascade = CascadeType.ALL, orphanRemoval = true)
  private List<Proceeding> proceedings;

  // Many other fields can be added following a similar pattern...

}
