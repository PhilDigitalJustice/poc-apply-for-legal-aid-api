package uk.gov.laa.apply.controller;

import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import uk.gov.laa.apply.service.ApplicationService;
import uk.gov.laa.legal.aid.api.ApplicationsApi;
import uk.gov.laa.legal.aid.model.Application;
import uk.gov.laa.legal.aid.model.Applications;

@RestController
@RequiredArgsConstructor
public class ApplicationController implements ApplicationsApi {

  private final ApplicationService service;

  @Override
  public ResponseEntity<Application> getApplicationById(final UUID id) {
    return new ResponseEntity<>(service.getApplicationById(id), HttpStatus.OK);
  }

  @Override
  public ResponseEntity<Applications> getApplications(final Pageable pageable) {
    return new ResponseEntity<>(service.getApplications(pageable), HttpStatus.OK);
  }
}
