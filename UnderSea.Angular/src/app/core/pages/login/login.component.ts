import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroupDirective, NgForm, Validators, FormGroup, FormBuilder } from '@angular/forms';
import { ErrorStateMatcher } from '@angular/material/core';

import { Router } from '@angular/router';

import { HttpClient } from '@angular/common/http';
import { AuthService } from '../../services/auth.service';
import { tap } from 'rxjs/operators';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  reg: boolean;

  loginForm: FormGroup;
  regForm: FormGroup;

  formBuilder: FormBuilder = new FormBuilder();

  regformBuilder: FormBuilder = new FormBuilder();


  constructor(private router: Router, public http: HttpClient, private authService: AuthService, private snackbar: MatSnackBar) { }

  ngOnInit(): void {

    this.loginForm = this.formBuilder.group({
      username: ['', [Validators.required, this.noWhitespaceValidator]],
      password: ['', [Validators.required, this.noWhitespaceValidator]]
    });

    this.regForm = this.regformBuilder.group({
      regUsername: ['', [Validators.required, this.noWhitespaceValidator]],
      regPassword: ['', [Validators.required, this.noWhitespaceValidator]],
      passConfirm: ['', [Validators.required, this.noWhitespaceValidator]],
      country: ['', [Validators.required, this.noWhitespaceValidator]]
    });

    this.reg = false;
  }

  login(): void {
    
    this.authService.login(this.loginForm.controls.username.value, this.loginForm.controls.password.value).pipe(
      tap(tokens => {
        if (tokens.accessToken != null) {
          this.router.navigate(['/main']);
        }
      })
    ).subscribe();
  }

  signup(): void {
    this.authService.signup(
      this.regForm.controls.regUsername.value,
      this.regForm.controls.regPassword.value,
      this.regForm.controls.country.value).pipe(
        tap(res => {
          this.snackbar.open('Sikeres regisztráció', 'Bezár', {
            duration: 3000,
            panelClass: ['my-snackbar'],
          });
          if (res.accessToken != null) {
            this.reg = false;
            this.router.navigate(['/main']);
          }
        })
      ).subscribe();
  }

  _true(): void {
    this.reg = true;
    this.loginForm.reset();
  }

  _false(): void {
    this.reg = false;
    this.regForm.reset();
  }

  public noWhitespaceValidator(control: FormControl) {
    const isWhitespace = (control.value || '').trim().length === 0;
    const isValid = !isWhitespace;
    return isValid ? null : { 'whitespace': true };
  }

}