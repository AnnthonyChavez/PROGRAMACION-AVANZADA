// src/app/layout.js
'use client'; // Importante para componentes de layout con estado o interactividad

import React, { useState, useEffect } from 'react'; // Agregamos useEffect
import Link from 'next/link';
import { usePathname } from 'next/navigation'; // Hook para obtener la ruta actual
import './globals.css'; // Asegúrate de que tus estilos globales de Tailwind estén aquí

export default function RootLayout({ children }) {
  const pathname = usePathname(); // Obtiene la ruta actual
  const [activePage, setActivePage] = useState(''); // Estado para la página activa

  // Actualiza el estado de la página activa cuando cambia la ruta
  useEffect(() => {
    if (pathname.includes('/pacientes')) {
      setActivePage('pacientes');
    } else if (pathname.includes('/medicos')) {
      setActivePage('medicos');
    } else if (pathname.includes('/consultorios')) {
      setActivePage('consultorios');
    } else if (pathname.includes('/citas')) {
      setActivePage('citas');
    } else {
      setActivePage(''); // Página de inicio o desconocida
    }
  }, [pathname]);

  return (
    <html lang="es">
      <head>
        <title>Sistema de Citas Médicas</title>
        {/* Aquí puedes añadir otros meta tags, favicons, etc. */}
      </head>
      <body className="min-h-screen bg-gray-100 font-sans text-gray-900 antialiased flex flex-col">
        {/* Navbar de Navegación */}
        <nav className="bg-blue-800 p-4 shadow-md">
          <div className="container mx-auto flex justify-center space-x-6">
            <Link href="/pacientes" passHref>
              <button
                className={`px-5 py-2 rounded-lg font-medium transition duration-300 ${
                  activePage === 'pacientes' ? 'bg-blue-600 text-white shadow-lg' : 'text-blue-200 hover:bg-blue-700 hover:text-white'
                }`}
              >
                Pacientes
              </button>
            </Link>
            <Link href="/medicos" passHref>
              <button
                className={`px-5 py-2 rounded-lg font-medium transition duration-300 ${
                  activePage === 'medicos' ? 'bg-blue-600 text-white shadow-lg' : 'text-blue-200 hover:bg-blue-700 hover:text-white'
                }`}
              >
                Médicos
              </button>
            </Link>
            <Link href="/consultorios" passHref>
              <button
                className={`px-5 py-2 rounded-lg font-medium transition duration-300 ${
                  activePage === 'consultorios' ? 'bg-blue-600 text-white shadow-lg' : 'text-blue-200 hover:bg-blue-700 hover:text-white'
                }`}
              >
                Consultorios
              </button>
            </Link>
            <Link href="/citas" passHref>
              <button
                className={`px-5 py-2 rounded-lg font-medium transition duration-300 ${
                  activePage === 'citas' ? 'bg-blue-600 text-white shadow-lg' : 'text-blue-200 hover:bg-blue-700 hover:text-white'
                }`}
              >
                Citas
              </button>
            </Link>
          </div>
        </nav>

        {/* Contenido principal de la página actual */}
        <main className="flex-grow p-6">
          {children} {/* Esto renderizará la página actual (ej. PacientesPage) */}
        </main>

        {/* Footer */}
        <footer className="bg-gray-800 text-white text-center p-4 mt-8 rounded-t-lg">
          <p>&copy; 2025 Sistema de Citas Médicas. Todos los derechos reservados.</p>
        </footer>
      </body>
    </html>
  );
}
