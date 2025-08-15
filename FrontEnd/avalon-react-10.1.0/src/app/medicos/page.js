'use client'; // Importante para componentes con estado y efectos en App Router

import React, { useState, useEffect } from 'react';

// URL base de tu backend Flask
const API_BASE_URL = 'http://localhost:5000/api/v1'; // Asegúrate que esta URL sea correcta

function MedicosView() {
  const [medicos, setMedicos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [editingMedico, setEditingMedico] = useState(null);
  const [formData, setFormData] = useState({
    nombre: '',
    apellido: '',
    especialidad: ''
  });

  const fetchMedicos = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetch(`${API_BASE_URL}/medicos`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setMedicos(data);
    } catch (e) {
      console.error("Error fetching medicos:", e);
      setError("Error al cargar médicos. Por favor, inténtalo de nuevo.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchMedicos();
  }, []);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    const url = editingMedico
      ? `${API_BASE_URL}/medicos/${editingMedico.id}`
      : `${API_BASE_URL}/medicos`;
    const method = editingMedico ? 'PUT' : 'POST';

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
      console.log(result.message);
      setFormData({ nombre: '', apellido: '', especialidad: '' });
      setEditingMedico(null);
      fetchMedicos();
    } catch (e) {
      console.error("Error al guardar médico:", e);
      setError(`Error al guardar médico: ${e.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (medico) => {
    setEditingMedico(medico);
    setFormData({
      nombre: medico.nombre,
      apellido: medico.apellido,
      especialidad: medico.especialidad
    });
  };

  const handleDelete = async (id) => {
    if (!window.confirm("¿Estás seguro de que quieres eliminar este médico?")) {
      return;
    }
    setError(null);
    setLoading(true);
    try {
      const response = await fetch(`${API_BASE_URL}/medicos/${id}`, {
        method: 'DELETE',
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
      }
      console.log("Médico eliminado correctamente.");
      fetchMedicos();
    } catch (e) {
      console.error("Error al eliminar médico:", e);
      setError(`Error al eliminar médico: ${e.message}`);
    } finally {
      setLoading(false);
    }
  };

  if (loading && medicos.length === 0) return <div className="text-center py-4 text-blue-500">Cargando médicos...</div>;
  if (error) return <div className="text-center py-4 text-red-500">Error: {error}</div>;

  return (
    <div className="container mx-auto p-4 bg-white shadow-lg rounded-xl">
      <h2 className="text-3xl font-bold text-center mb-6 text-gray-800">Gestión de Médicos</h2>

      {/* Formulario para añadir/editar médico */}
      <form onSubmit={handleSubmit} className="mb-8 p-6 bg-gray-50 rounded-lg shadow-inner">
        <h3 className="text-2xl font-semibold mb-4 text-gray-700">
          {editingMedico ? 'Editar Médico' : 'Añadir Nuevo Médico'}
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
            type="text"
            name="especialidad"
            placeholder="Especialidad"
            value={formData.especialidad}
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
            {loading ? 'Guardando...' : editingMedico ? 'Actualizar Médico' : 'Añadir Médico'}
          </button>
          {editingMedico && (
            <button
              type="button"
              onClick={() => { setEditingMedico(null); setFormData({ nombre: '', apellido: '', especialidad: '' }); }}
              className="px-6 py-3 bg-gray-400 text-white font-semibold rounded-lg shadow-md hover:bg-gray-500 transition duration-300"
            >
              Cancelar Edición
            </button>
          )}
        </div>
      </form>

      {/* Lista de médicos */}
      <h3 className="text-2xl font-semibold mb-4 text-gray-700">Listado de Médicos</h3>
      {medicos.length === 0 ? (
        <p className="text-center text-gray-500">No hay médicos registrados.</p>
      ) : (
        <div className="overflow-x-auto rounded-lg shadow-md">
          <table className="min-w-full bg-white divide-y divide-gray-200">
            <thead className="bg-gray-100">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nombre</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Apellido</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Especialidad</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {medicos.map((medico) => (
                <tr key={medico.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{medico.id}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{medico.nombre}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{medico.apellido}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{medico.especialidad}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                    <button
                      onClick={() => handleEdit(medico)}
                      className="px-4 py-2 bg-yellow-500 text-white rounded-md hover:bg-yellow-600 transition duration-200 shadow-sm"
                    >
                      Editar
                    </button>
                    <button
                      onClick={() => handleDelete(medico.id)}
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

export default function MedicosPage() {
  return <MedicosView />;
}
