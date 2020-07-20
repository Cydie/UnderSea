import { Component, OnInit } from '@angular/core';
import { IUpgradesViewModel } from '../models/upgrades.model';

@Component({
  selector: 'app-upgrades-page',
  templateUrl: './upgrades.page.component.html',
  styleUrls: ['./upgrades.page.component.scss']
})
export class UpgradesPageComponent implements OnInit {

  clicked = false;
  isSelected: string;

  mudTractor: IUpgradesViewModel = {
    name: 'Iszaptraktor',
    upgrade: 'krumpli termesztését',
    percent: 20
  };

  mudHarvester: IUpgradesViewModel = {
    name: 'Iszapkombájn',
    upgrade: 'korall termesztését',
    percent: 15
  };

    coralWall: IUpgradesViewModel = {
    name: 'Korallfal',
    upgrade: 'védelmi pontokat',
    percent: 20
  };

  sonarCanon: IUpgradesViewModel = {
    name: 'Szonárágyú',
    upgrade: 'támadópontokat',
    percent: 20
  };

  underwaterMartialArts: IUpgradesViewModel = {
    name: 'Vízalatti harcművészetek',
    upgrade: 'védelmi és támadóerőt',
    percent: 10
  };

  alchemy: IUpgradesViewModel = {
    name: 'Alkímia',
    upgrade: 'beszedett adót',
    percent: 30
  };

  constructor() { }

  ngOnInit(): void {
  }

  enableButton(value): void{
    this.isSelected = value;
    this.clicked = true;
  }

}