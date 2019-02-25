/***************************************************************************

Copyright (c) 2016, EPAM SYSTEMS INC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

****************************************************************************/

import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { catchError, map } from 'rxjs/operators';

import { ErrorUtils } from '../util';
import { ApplicationServiceFacade } from './applicationServiceFacade.service';

@Injectable()
export class LibrariesInstallationService {
  constructor(private applicationServiceFacade: ApplicationServiceFacade) {}

  public getGroupsList(exploratory, computational?): Observable<Response> {
    let body = `?exploratory_name=${exploratory}`;
    if (computational) body += `&computational_name=${computational}`;

    return this.applicationServiceFacade
      .buildGetGroupsList(body)
      .pipe(
        map(response => response),
        catchError(ErrorUtils.handleServiceError));
  }

  public getAvailableLibrariesList(data): Observable<{}> {
    return this.applicationServiceFacade
      .buildGetAvailableLibrariesList(data)
      .pipe(
        map(response => response),
        catchError(ErrorUtils.handleServiceError));
  }

  public getAvailableDependencies(data): Observable<{}> {
    const body = `/maven?artifact=${data}`;

    return this.applicationServiceFacade
      .buildGetAvailableDependenciest(body)
      .pipe(
        map(response => response),
        catchError(ErrorUtils.handleServiceError));
  }

  public installLibraries(data): Observable<{}> {
    return this.applicationServiceFacade
      .buildInstallLibraries(data)
      .pipe(
        map(response => response),
        catchError(ErrorUtils.handleServiceError));
  }

  public getInstalledLibrariesList(exploratory): Observable<{}> {
    const body = `?exploratory_name=${exploratory}`;

    return this.applicationServiceFacade
      .buildGetInstalledLibrariesList(body)
      .pipe(
        map(response => response),
        catchError(ErrorUtils.handleServiceError));
  }

  public getInstalledLibsByResource(exploratory, computational?): Observable<{}> {
    let body = `?exploratory_name=${exploratory}`;
    if (computational) body += `&computational_name=${computational}`;

    return this.applicationServiceFacade
      .buildGetInstalledLibsByResource(body)
      .pipe(
        map(response => response),
        catchError(ErrorUtils.handleServiceError));
  }
}
