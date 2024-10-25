package uk.gov.laa.apply.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.springframework.data.domain.Page;
import uk.gov.laa.legal.aid.model.Application;
import uk.gov.laa.legal.aid.model.Applications;

@Mapper(componentModel = "spring")
public interface ApplicationMapper {

  @Mapping(target = "createdAt", ignore = true)
  Application toApplication(uk.gov.laa.apply.entity.Application application);

  Applications toApplications(Page<uk.gov.laa.apply.entity.Application> applications);

}
