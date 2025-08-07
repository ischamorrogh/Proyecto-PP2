import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = 'http://localhost:3000/api/usuarios'; // Ruta base del backend

  constructor(private http: HttpClient) {}

  login(email: string, password: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/login`, { email, contrasena: password });
  }

  registro(data: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/registro`, data);
  }

  logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('usuario');
  }

  isAuthenticated(): boolean {
    return !!localStorage.getItem('token');
  }

  getUsuario(): any {
    const usuario = localStorage.getItem('usuario');
    return usuario ? JSON.parse(usuario) : null;
  }

  getToken(): string | null {
    return localStorage.getItem('token');
  }
}
