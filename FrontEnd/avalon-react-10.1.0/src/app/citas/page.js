'use client'; // Importante para componentes con estado y efectos en App Router

import React, { useState, useEffect } from 'react';

// URL base de tu backend Flask
const API_BASE_URL = 'http://localhost:5000/api/v1'; // Asegúrate que esta URL sea correcta

function CitasView() {
  const [citas, setCitas] = useState([]);
  const [pacientes, setPacientes] = useState([]);
  const [medicos, setMedicos] = useState([]);
  const [consultorios, setConsultorios] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [editingCita, setEditingCita] = useState(null);
  const [formData, setFormData] = useState({
    paciente_id: '',
    medico_id: '',
    consultorio_id: '',
    fecha: '',
    hora: ''
  });

  // Cargar datos iniciales (citas, pacientes, médicos, consultorios)
  const fetchData = async () => {
    setLoading(true);
    setError(null);
    try {
      const [citasRes, pacientesRes, medicosRes, consultoriosRes] = await Promise.all([
        fetch(`${API_BASE_URL}/citas`),
        fetch(`${API_BASE_URL}/pacientes`),
        fetch(`${API_BASE_URL}/medicos`),
        fetch(`${API_BASE_URL}/consultorios`)
      ]);

      const citasData = await citasRes.json();
      const pacientesData = await pacientesRes.json();
      const medicosData = await medicosRes.json();
      const consultoriosData = await consultoriosRes.json();

      if (!citasRes.ok) throw new Error(citasData.message || 'Error al cargar citas');
      if (!pacientesRes.ok) throw new Error(pacientesData.message || 'Error al cargar pacientes');
      if (!medicosRes.ok) throw new Error(medicosData.message || 'Error al cargar médicos');
      if (!consultoriosRes.ok) throw new Error(consultoriosData.message || 'Error al cargar consultorios');

      setCitas(citasData);
      setPacientes(pacientesData);
      setMedicos(medicosData);
      setConsultorios(consultoriosData);

    } catch (e) {
      console.error("Error fetching data for citas:", e);
      setError(`Error al cargar datos: ${e.message}`);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    const url = editingCita
      ? `${API_BASE_URL}/citas/${editingCita.id}`
      : `${API_BASE_URL}/citas`;
    const method = editingCita ? 'PUT' : 'POST';

    try {
      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...formData,
          paciente_id: parseInt(formData.paciente_id),
          medico_id: parseInt(formData.medico_id),
          consultorio_id: parseInt(formData.consultorio_id)
        }),
      });

      const result = await response.json();
      if (!response.ok) {
        throw new Error(result.message || `HTTP error! status: ${response.status}`);
      }
      console.log(result.message);
      setFormData({ paciente_id: '', medico_id: '', consultorio_id: '', fecha: '', hora: '' });
      setEditingCita(null);
      fetchData(); // Refrescar todas las listas
    } catch (e) {
      console.error("Error al guardar cita:", e);
      setError(`Error al guardar cita: ${e.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (cita) => {
    setEditingCita(cita);
    setFormData({
      paciente_id: cita.paciente_id,
      medico_id: cita.medico_id,
      consultorio_id: cita.consultorio_id,
      fecha: cita.fecha,
      hora: cita.hora
    });
  };

  const handleDelete = async (id) => {
    if (!window.confirm("¿Estás seguro de que quieres eliminar esta cita?")) {
      return;
    }
    setError(null);
    setLoading(true);
    try {
      const response = await fetch(`${API_BASE_URL}/citas/${id}`, {
        method: 'DELETE',
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
      }
      console.log("Cita eliminada correctamente.");
      fetchData(); // Refrescar la lista
    } catch (e) {
      console.error("Error al eliminar cita:", e);
      setError(`Error al eliminar cita: ${e.message}`);
    } finally {
      setLoading(false);
    }
  };

  // Helper para obtener nombre del paciente
  const getPacienteNombre = (id) => {
    const paciente = pacientes.find(p => p.id === id);
    return paciente ? `${paciente.nombre} ${paciente.apellido}` : 'Desconocido';
  };

  // Helper para obtener nombre del médico
  const getMedicoNombre = (id) => {
    const medico = medicos.find(m => m.id === id);
    return medico ? `${medico.nombre} ${medico.apellido}` : 'Desconocido';
  };

  // Helper para obtener número de consultorio
  const getConsultorioNumero = (id) => {
    const consultorio = consultorios.find(c => c.id === id);
    return consultorio ? consultorio.numero : 'Desconocido';
  };

  if (loading) return <div className="text-center py-4 text-blue-500">Cargando datos...</div>;
  if (error) return <div className="text-center py-4 text-red-500">Error: {error}</div>;

  return (
    <div className="container mx-auto p-4 bg-white shadow-lg rounded-xl">
      <h2 className="text-3xl font-bold text-center mb-6 text-gray-800">Gestión de Citas</h2>

      {/* Formulario para añadir/editar cita */}
      <form onSubmit={handleSubmit} className="mb-8 p-6 bg-gray-50 rounded-lg shadow-inner">
        <h3 className="text-2xl font-semibold mb-4 text-gray-700">
          {editingCita ? 'Editar Cita' : 'Añadir Nueva Cita'}
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <select
            name="paciente_id"
            value={formData.paciente_id}
            onChange={handleInputChange}
            required
            className="p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
          >
            <option value="">Selecciona Paciente</option>
            {pacientes.map(paciente => (
              <option key={paciente.id} value={paciente.id}>
                {paciente.nombre} {paciente.apellido}
              </option>
            ))}
          </select>

          <select
            name="medico_id"
            value={formData.medico_id}
            onChange={handleInputChange}
            required
            className="p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
          >
            <option value="">Selecciona Médico</option>
            {medicos.map(medico => (
              <option key={medico.id} value={medico.id}>
                {medico.nombre} {medico.apellido} ({medico.especialidad})
              </option>
            ))}
          </select>

          <select
            name="consultorio_id"
            value={formData.consultorio_id}
            onChange={handleInputChange}
            required
            className="p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
          >
            <option value="">Selecciona Consultorio</option>
            {consultorios.map(consultorio => (
              <option key={consultorio.id} value={consultorio.id}>
                Número: {consultorio.numero} (Piso: {consultorio.piso})
              </option>
            ))}
          </select>

          <input
            type="date"
            name="fecha"
            placeholder="Fecha (YYYY-MM-DD)"
            value={formData.fecha}
            onChange={handleInputChange}
            required
            className="p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
          />
          <input
            type="time"
            name="hora"
            placeholder="Hora (HH:MM:SS)"
            value={formData.hora}
            onChange={handleInputChange}
            required
            step="1" // Para incluir segundos
            className="p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400 transition duration-200"
          />
        </div>
        <div className="mt-6 flex justify-end space-x-3">
          <button
            type="submit"
            disabled={loading}
            className="px-6 py-3 bg-blue-600 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 transition duration-300 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {loading ? 'Guardando...' : editingCita ? 'Actualizar Cita' : 'Añadir Cita'}
          </button>
          {editingCita && (
            <button
              type="button"
              onClick={() => { setEditingCita(null); setFormData({ paciente_id: '', medico_id: '', consultorio_id: '', fecha: '', hora: '' }); }}
              className="px-6 py-3 bg-gray-400 text-white font-semibold rounded-lg shadow-md hover:bg-gray-500 transition duration-300"
            >
              Cancelar Edición
            </button>
          )}
        </div>
      </form>

      {/* Lista de citas */}
      <h3 className="text-2xl font-semibold mb-4 text-gray-700">Listado de Citas</h3>
      {citas.length === 0 ? (
        <p className="text-center text-gray-500">No hay citas registradas.</p>
      ) : (
        <div className="overflow-x-auto rounded-lg shadow-md">
          <table className="min-w-full bg-white divide-y divide-gray-200">
            <thead className="bg-gray-100">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Paciente</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Médico</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Consultorio</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Hora</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {citas.map((cita) => (
                <tr key={cita.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{cita.id}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{getPacienteNombre(cita.paciente_id)}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{getMedicoNombre(cita.medico_id)}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{getConsultorioNumero(cita.consultorio_id)}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{cita.fecha}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{cita.hora}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                    <button
                      onClick={() => handleEdit(cita)}
                      className="px-4 py-2 bg-yellow-500 text-white rounded-md hover:bg-yellow-600 transition duration-200 shadow-sm"
                    >
                      Editar
                    </button>
                    <button
                      onClick={() => handleDelete(cita.id)}
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

export default function CitasPage() {
  return <CitasView />;
}
