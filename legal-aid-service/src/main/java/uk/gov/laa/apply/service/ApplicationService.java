package uk.gov.laa.apply.service;

import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import uk.gov.laa.apply.mapper.ApplicationMapper;
import uk.gov.laa.apply.repository.ApplicationRepository;
import uk.gov.laa.legal.aid.model.Application;
import uk.gov.laa.legal.aid.model.Applications;

@Service
@RequiredArgsConstructor
@Slf4j
public class ApplicationService {

  private final ApplicationRepository repository;

  private final ApplicationMapper mapper;

  public Application getApplicationById(final UUID id) {
    return repository.findById(id)
        .map(mapper::toApplication)
        .orElseThrow(() -> new RuntimeException(
            String.format("Application with id %s not found", id)));
  }

  public Applications getApplications(final Pageable pageable) {
    uk.gov.laa.apply.entity.Application application = new uk.gov.laa.apply.entity.Application();
    return mapper.toApplications(repository.findAll(Example.of(application), pageable));
  }


}
