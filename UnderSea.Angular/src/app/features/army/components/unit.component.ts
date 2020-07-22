import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { IArmyViewModel } from '../models/army.model';

@Component({
  selector: 'app-unit',
  templateUrl: './unit.component.html',
  styleUrls: ['./unit.component.scss']
})
export class UnitComponent implements OnInit {

  @Input() unit: IArmyViewModel;
  @Input() image: string;
  @Input() buyNumber: number;

  @Output() clickAdd = new EventEmitter();
  @Output() clickDecrease = new EventEmitter();

  ngOnInit(): void {
  }

}