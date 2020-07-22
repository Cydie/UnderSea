import { Component, OnInit } from '@angular/core';
import { IBuildingsViewModel, ICatsViewModel } from '../models/buildings.model';
import { BuildingsService } from '../services/buildings.service';
import { tap, catchError } from 'rxjs/operators';
import { ICatsDto } from '../models/buildings.dto';
import { IBuildingInfoViewModel } from 'src/app/shared';
import { MatSnackBar } from '@angular/material/snack-bar';
import { of } from 'rxjs';

@Component({
  selector: 'app-buildings-page',
  templateUrl: './buildings.page.component.html',
  styleUrls: ['./buildings.page.component.scss']
})
export class BuildingsPageComponent implements OnInit {

  clicked = false;
  isSelected: string;
  purchaseId: number;
  buildings: IBuildingInfoViewModel[];

  constructor(private service: BuildingsService, private snackbar: MatSnackBar) { }

  ngOnInit(): void {
    this.service.getBuildings().pipe(
      tap(res => this.buildings = res),
      catchError(error => console.assert)
    ).subscribe();

  }

  enableButton(value: string, id: number): void{
    this.isSelected = value;
    this.purchaseId = id;
    this.clicked = true;
  }

  buyBuilding(): void{
    this.service.buyBuilding(this.purchaseId
      ).pipe(
        tap(res => {
          this.snackbar.open('Sikeres vétel!', 'Bezár', {
            duration: 3000,
            panelClass: ['my-snackbar'],
          });
        }),
        catchError(err => {
          return of(this.snackbar.open('A művelet sikertelen', 'Bezár', {
            duration: 3000,
            panelClass: ['my-snackbar'],
          }));
        })
      ).subscribe();
  }

}
