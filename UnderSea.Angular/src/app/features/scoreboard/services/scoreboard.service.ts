import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import { ApiClient, ScoreboardViewModel } from '../../../shared/index';

@Injectable({
    providedIn: 'root',
  })
  export class ScoreboardService {

    constructor(private http: HttpClient, private client: ApiClient) { }

    getUser(term: string): Observable<ScoreboardViewModel[]>{
        return this.client.scoreboard(term, 1, 10);
    }
  }
