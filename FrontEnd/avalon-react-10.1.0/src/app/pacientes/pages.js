'use client'; // Importante para componentes con estado y efectos en App Router

import React, { useState, useEffect } from 'react';

// URL base de tu backend Flask
const API_BASE_URL = 'http://localhost:5000/api/v1'; // Asegúrate que esta URL sea correcta

function PacientesView() {
  const [pacientes, setPacientes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [editingPaciente, setEditingPaciente] = useState(null); // Para editar un paciente
  const [formData, setFormData] = useState({
    nombre: '',
    apellido: '',
    fecha_nacimiento: '',
    email: ''
  });

  // Función para obtener todos los pacientes
  const fetchPacientes = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetch(`${API_BASE_URL}/pacientes`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setPacientes(data);
    } catch (e) {
      console.error("Error fetching pacientes:", e);
      setError("Error al cargar pacientes. Por favor, inténtalo de nuevo.");
    } finally {
      setLoading(false);
    }
  };

  // Cargar pacientes al montar el componente
  useEffect(() => {
    fetchPacientes();
  }, []);

  // Manejar cambios en el formulario
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  // Manejar el envío del formulario (crear/actualizar paciente)
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setLoading(true); // Activar loading para la operación de guardado

    const url = editingPaciente
      ? `${API_BASE_URL}/pacientes/${editingPaciente.id}`
      : `${API_BASE_URL}/pacientes`;
    const method = editingPaciente ? 'PUT' : 'POST';

    try {
      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      const result = await response.json();
      if (!response.ok) {
        throw new Error(result.message || `HTTP error! status: ${response.status}`);
      }
      console.log(result.message); // Mensaje de éxito del backend
      setFormData({ nombre: '', apellido: '', fecha_nacimiento: '', email: '' });
      setEditingPaciente(null); // Resetear modo edición
      fetchPacientes(); // Refrescar la lista de pacientes
    } catch (e) {
      console.error("Error al guardar paciente:", e);
      setError(`Error al guardar paciente: ${e.message}`);
    } finally {
      setLoading(false); // Desactivar loading
    }
  };

  // Función para iniciar la edición de un paciente
  const handleEdit = (paciente) => {
    setEditingPaciente(paciente);
    setFormData({
      nombre: paciente.nombre,
      apellido: paciente.apellido,
      fecha_nacimiento: paciente.fecha_nacimiento,
      email: paciente.email
    });
  };

  // Función para eliminar un paciente
  const handleDelete = async (id) => {
    if (!window.confirm("¿Estás seguro de que quieres eliminar este paciente?")) {
      return;
    }
    setError(null);
    setLoading(true);
    try {
      const response = await fetch(`${API_BASE_URL}/pacientes/${id}`, {
        method: 'DELETE',
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
      }
      console.log("Paciente eliminado correctamente.");
      fetchPacientes(); // Refrescar la lista
    } catch (e) {
      console.error("Error al eliminar paciente:", e);
      setError(`Error al eliminar paciente: ${e.message}`);
    } finally {
      setLoading(false);
    }
  };

  if (loading && pacientes.length === 0) return <div className="text-center py-4 text-blue-500">Cargando pacientes...</div>;
  if (error) return <div className="text-center py-4 text-red-500">Error: {error}</div>;

  return (
    <div className="container mx-auto p-4 bg-white shadow-lg rounded-xl">
      <h2 className="text-3xl font-bold text-center mb-6 text-gray-800">Gestión de Pacientes</h2>

      {/* Formulario para añadir/editar paciente */}
      <form onSubmit={handleSubmit} className="mb-8 p-6 bg-gray-50 rounded-lg shadow-inner">
        <h3 className="text-2xl font-semibold mb-4 text-gray-700">
          {editingPaciente ? 'Editar Paciente' : 'Añadir Nuevo Paciente'}
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <input
            type="text"
            name="nombre"
            placeholder="Nombre"
            value={formData.nombre}
            onChange={handleInputChange}
            required
            className="p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
          />
          <input
            type="text"
            name="apellido"
            placeholder="Apellido"
            value={formData.apellido}
            onChange={handleInputChange}
            required
            className="p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
          />
          <input
            type="date"
            name="fecha_nacimiento"
            placeholder="Fecha de Nacimiento (YYYY-MM-DD)"
            value={formData.fecha_nacimiento}
            onChange={handleInputChange}
            required
            className="p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
          />
          <input
            type="email"
            name="email"
            placeholder="Email"
            value={formData.email}
            onChange={handleInputChange}
            required
            className="p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
          />
        </div>
        <div className="mt-6 flex justify-end space-x-3">
          <button
            type="submit"
            disabled={loading}
            className="px-6 py-3 bg-blue-600 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 transition duration-300 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {loading ? 'Guardando...' : editingPaciente ? 'Actualizar Paciente' : 'Añadir Paciente'}
          </button>
          {editingPaciente && (
            <button
              type="button"
              onClick={() => { setEditingPaciente(null); setFormData({ nombre: '', apellido: '', fecha_nacimiento: '', email: '' }); }}
              className="px-6 py-3 bg-gray-400 text-white font-semibold rounded-lg shadow-md hover:bg-gray-500 transition duration-300"
            >
              Cancelar Edición
            </button>
          )}
        </div>
      </form>

      {/* Lista de pacientes */}
      <h3 className="text-2xl font-semibold mb-4 text-gray-700">Listado de Pacientes</h3>
      {pacientes.length === 0 ? (
        <p className="text-center text-gray-500">No hay pacientes registrados.</p>
      ) : (
        <div className="overflow-x-auto rounded-lg shadow-md">
          <table className="min-w-full bg-white divide-y divide-gray-200">
            <thead className="bg-gray-100">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nombre</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Apellido</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">F. Nacimiento</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {pacientes.map((paciente) => (
                <tr key={paciente.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{paciente.id}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{paciente.nombre}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{paciente.apellido}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{paciente.fecha_nacimiento}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{paciente.email}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                    <button
                      onClick={() => handleEdit(paciente)}
                      className="px-4 py-2 bg-yellow-500 text-white rounded-md hover:bg-yellow-600 transition duration-200 shadow-sm"
                    >
                      Editar
                    </button>
                    <button
                      onClick={() => handleDelete(paciente.id)}
                      className="px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-600 transition duration-200 shadow-sm"
                    >
                      Eliminar
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

export default function PacientesPage() {
  return <PacientesView />;
}
