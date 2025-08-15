'use client'; // Importante para componentes con estado y efectos en App Router

import React, { useState, useEffect } from 'react';

// URL base de tu backend Flask
const API_BASE_URL = 'http://localhost:5000/api/v1'; // Asegúrate que esta URL sea correcta

function ConsultoriosView() {
  const [consultorios, setConsultorios] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [editingConsultorio, setEditingConsultorio] = useState(null);
  const [formData, setFormData] = useState({
    numero: '',
    piso: ''
  });

  const fetchConsultorios = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetch(`${API_BASE_URL}/consultorios`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setConsultorios(data);
    } catch (e) {
      console.error("Error fetching consultorios:", e);
      setError("Error al cargar consultorios. Por favor, inténtalo de nuevo.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchConsultorios();
  }, []);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    const url = editingConsultorio
      ? `${API_BASE_URL}/consultorios/${editingConsultorio.id}`
      : `${API_BASE_URL}/consultorios`;
    const method = editingConsultorio ? 'PUT' : 'POST';

    try {
      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ ...formData, piso: parseInt(formData.piso) }), // Asegurar que piso es int
      });

      const result = await response.json();
      if (!response.ok) {
        throw new Error(result.message || `HTTP error! status: ${response.status}`);
      }
      console.log(result.message);
      setFormData({ numero: '', piso: '' });
      setEditingConsultorio(null);
      fetchConsultorios();
    } catch (e) {
      console.error("Error al guardar consultorio:", e);
      setError(`Error al guardar consultorio: ${e.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (consultorio) => {
    setEditingConsultorio(consultorio);
    setFormData({
      numero: consultorio.numero,
      piso: consultorio.piso
    });
  };

  const handleDelete = async (id) => {
    if (!window.confirm("¿Estás seguro de que quieres eliminar este consultorio?")) {
      return;
    }
    setError(null);
    setLoading(true);
    try {
      const response = await fetch(`${API_BASE_URL}/consultorios/${id}`, {
        method: 'DELETE',
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
      }
      console.log("Consultorio eliminado correctamente.");
      fetchConsultorios();
    } catch (e) {
      console.error("Error al eliminar consultorio:", e);
      setError(`Error al eliminar consultorio: ${e.message}`);
    } finally {
      setLoading(false);
    }
  };

  if (loading && consultorios.length === 0) return <div className="text-center py-4 text-blue-500">Cargando consultorios...</div>;
  if (error) return <div className="text-center py-4 text-red-500">Error: {error}</div>;

  return (
    <div className="container mx-auto p-4 bg-white shadow-lg rounded-xl">
      <h2 className="text-3xl font-bold text-center mb-6 text-gray-800">Gestión de Consultorios</h2>

      {/* Formulario para añadir/editar consultorio */}
      <form onSubmit={handleSubmit} className="mb-8 p-6 bg-gray-50 rounded-lg shadow-inner">
        <h3 className="text-2xl font-semibold mb-4 text-gray-700">
          {editingConsultorio ? 'Editar Consultorio' : 'Añadir Nuevo Consultorio'}
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <input
            type="text"
            name="numero"
            placeholder="Número de Consultorio"
            value={formData.numero}
            onChange={handleInputChange}
            required
            className="p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
          />
          <input
            type="number"
            name="piso"
            placeholder="Piso"
            value={formData.piso}
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
            {loading ? 'Guardando...' : editingConsultorio ? 'Actualizar Consultorio' : 'Añadir Consultorio'}
          </button>
          {editingConsultorio && (
            <button
              type="button"
              onClick={() => { setEditingConsultorio(null); setFormData({ numero: '', piso: '' }); }}
              className="px-6 py-3 bg-gray-400 text-white font-semibold rounded-lg shadow-md hover:bg-gray-500 transition duration-300"
            >
              Cancelar Edición
            </button>
          )}
        </div>
      </form>

      {/* Lista de consultorios */}
      <h3 className="text-2xl font-semibold mb-4 text-gray-700">Listado de Consultorios</h3>
      {consultorios.length === 0 ? (
        <p className="text-center text-gray-500">No hay consultorios registrados.</p>
      ) : (
        <div className="overflow-x-auto rounded-lg shadow-md">
          <table className="min-w-full bg-white divide-y divide-gray-200">
            <thead className="bg-gray-100">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Número</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Piso</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {consultorios.map((consultorio) => (
                <tr key={consultorio.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{consultorio.id}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{consultorio.numero}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{consultorio.piso}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                    <button
                      onClick={() => handleEdit(consultorio)}
                      className="px-4 py-2 bg-yellow-500 text-white rounded-md hover:bg-yellow-600 transition duration-200 shadow-sm"
                    >
                      Editar
                    </button>
                    <button
                      onClick={() => handleDelete(consultorio.id)}
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

export default function ConsultoriosPage() {
  return <ConsultoriosView />;
}
