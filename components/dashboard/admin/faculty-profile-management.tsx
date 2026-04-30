'use client'

import { useEffect, useMemo, useState } from 'react'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import { Edit, Plus, Save, Trash2, X } from 'lucide-react'

type FacultyProfileRecord = {
  id: string
  user_id: string
  employee_id: string
  department: string
  position: string
  specialization: string | null
  hire_date: string
  created_at: string
  updated_at: string
  users?: {
    id: string
    name: string
    email: string
    role: string
    status: string
  }
}

type FacultyProfileForm = {
  userId: string
  employeeId: string
  department: string
  position: string
  specialization?: string
  hireDate: string
}

const initialForm: FacultyProfileForm = {
  userId: '',
  employeeId: '',
  department: '',
  position: '',
  specialization: '',
  hireDate: '',
}

const departments = ['Computer Science', 'Information Technology', 'Engineering', 'Business', 'Liberal Arts', 'Sciences', 'Education']
const positions = ['Professor', 'Associate Professor', 'Assistant Professor', 'Instructor', 'Lecturer']

export function FacultyProfileManagement() {
  const [profiles, setProfiles] = useState<FacultyProfileRecord[]>([])
  const [search, setSearch] = useState('')
  const [isLoading, setIsLoading] = useState(true)
  const [isSaving, setIsSaving] = useState(false)
  const [error, setError] = useState('')
  const [showCreate, setShowCreate] = useState(false)
  const [createForm, setCreateForm] = useState<FacultyProfileForm>(initialForm)
  const [editingId, setEditingId] = useState<string | null>(null)
  const [editForm, setEditForm] = useState<FacultyProfileForm>(initialForm)

  const loadData = async () => {
    setIsLoading(true)
    setError('')

    try {
      const response = await fetch('/api/faculty-profiles?limit=500&sort=employee_id&order=asc')
      const payload = await response.json()

      if (!response.ok || !payload.success) {
        throw new Error(payload.message || 'Failed to load faculty profiles.')
      }

      const profilesData = Array.isArray(payload.data?.profiles) ? (payload.data.profiles as FacultyProfileRecord[]) : []
      setProfiles(profilesData)
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : 'Failed to load faculty profiles.')
    } finally {
      setIsLoading(false)
    }
  }

  useEffect(() => {
    loadData()
  }, [])

  const filteredProfiles = useMemo(() => {
    const term = search.trim().toLowerCase()
    if (!term) return profiles

    return profiles.filter((profile) => {
      return [
        profile.employee_id,
        profile.users?.name,
        profile.department,
        profile.position,
      ].some((value) => String(value ?? '').toLowerCase().includes(term))
    })
  }, [profiles, search])

  const onCreateProfile = async (event: React.FormEvent) => {
    event.preventDefault()
    setError('')

    if (!createForm.userId || !createForm.employeeId || !createForm.department || !createForm.position || !createForm.hireDate) {
      setError('Please complete all required fields: User ID, Employee ID, Department, Position, Hire Date.')
      return
    }

    setIsSaving(true)

    try {
      const response = await fetch('/api/faculty-profiles', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          userId: createForm.userId,
          employeeId: createForm.employeeId,
          department: createForm.department,
          position: createForm.position,
          specialization: createForm.specialization,
          hireDate: createForm.hireDate,
        }),
      })

      const payload = await response.json()
      if (!response.ok || !payload.success) {
        throw new Error(payload.message || 'Failed to create faculty profile.')
      }

      setCreateForm(initialForm)
      setShowCreate(false)
      await loadData()
    } catch (createError) {
      setError(createError instanceof Error ? createError.message : 'Failed to create faculty profile.')
    } finally {
      setIsSaving(false)
    }
  }

  const onStartEdit = (profile: FacultyProfileRecord) => {
    setEditingId(profile.id)
    setEditForm({
      userId: profile.user_id,
      employeeId: profile.employee_id,
      department: profile.department,
      position: profile.position,
      specialization: profile.specialization || '',
      hireDate: profile.hire_date,
    })
  }

  const onCancelEdit = () => {
    setEditingId(null)
    setEditForm(initialForm)
  }

  const onSaveEdit = async () => {
    if (!editingId) return
    setError('')
    setIsSaving(true)

    try {
      const response = await fetch('/api/faculty-profiles', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          id: editingId,
          user_id: editForm.userId,
          employee_id: editForm.employeeId,
          department: editForm.department,
          position: editForm.position,
          specialization: editForm.specialization,
          hire_date: editForm.hireDate,
        }),
      })

      const payload = await response.json()
      if (!response.ok || !payload.success) {
        throw new Error(payload.message || 'Failed to update faculty profile.')
      }

      onCancelEdit()
      await loadData()
    } catch (updateError) {
      setError(updateError instanceof Error ? updateError.message : 'Failed to update faculty profile.')
    } finally {
      setIsSaving(false)
    }
  }

  const onDeleteProfile = async (id: string) => {
    const isConfirmed = window.confirm('Delete this faculty profile? This action cannot be undone.')
    if (!isConfirmed) return

    try {
      const response = await fetch(`/api/faculty-profiles?id=${id}`, { method: 'DELETE' })
      const payload = await response.json()

      if (!response.ok || !payload.success) {
        throw new Error(payload.message || 'Failed to delete faculty profile.')
      }

      setProfiles((prev) => prev.filter((profile) => profile.id !== id))
    } catch (deleteError) {
      setError(deleteError instanceof Error ? deleteError.message : 'Failed to delete faculty profile.')
    }
  }

  return (
    <Card className="bg-gray-900 border-gray-800">
      <CardHeader>
        <div className="flex items-center justify-between">
          <div>
            <CardTitle className="text-white">Faculty Profiles</CardTitle>
            <CardDescription>Manage faculty member information and department assignments</CardDescription>
          </div>
          <Button className="bg-amber-600 hover:bg-amber-700" onClick={() => setShowCreate((prev) => !prev)}>
            <Plus className="h-4 w-4 mr-2" />
            {showCreate ? 'Close' : 'New Faculty'}
          </Button>
        </div>
      </CardHeader>
      <CardContent className="space-y-4">
        {showCreate && (
          <form className="grid gap-3 md:grid-cols-4 rounded-lg border border-gray-700 bg-gray-800/40 p-4" onSubmit={onCreateProfile}>
            <Input value={createForm.userId} onChange={(e) => setCreateForm((p) => ({ ...p, userId: e.target.value }))} placeholder="User ID" className="bg-gray-800 border-gray-700 text-white" />
            <Input value={createForm.employeeId} onChange={(e) => setCreateForm((p) => ({ ...p, employeeId: e.target.value }))} placeholder="Employee ID" className="bg-gray-800 border-gray-700 text-white" />
            <select value={createForm.department} onChange={(e) => setCreateForm((p) => ({ ...p, department: e.target.value }))} className="h-10 rounded-md border border-gray-700 bg-gray-800 px-3 text-sm text-white">
              <option value="">Select Department</option>
              {departments.map((dept) => (
                <option key={dept} value={dept}>{dept}</option>
              ))}
            </select>
            <select value={createForm.position} onChange={(e) => setCreateForm((p) => ({ ...p, position: e.target.value }))} className="h-10 rounded-md border border-gray-700 bg-gray-800 px-3 text-sm text-white">
              <option value="">Select Position</option>
              {positions.map((position) => (
                <option key={position} value={position}>{position}</option>
              ))}
            </select>
            <Input value={createForm.specialization} onChange={(e) => setCreateForm((p) => ({ ...p, specialization: e.target.value }))} placeholder="Specialization (Optional)" className="bg-gray-800 border-gray-700 text-white" />
            <Input type="date" value={createForm.hireDate} onChange={(e) => setCreateForm((p) => ({ ...p, hireDate: e.target.value }))} placeholder="Hire Date" className="bg-gray-800 border-gray-700 text-white" />
            <div className="md:col-span-4 flex justify-end">
              <Button type="submit" disabled={isSaving} className="bg-green-600 hover:bg-green-700">
                {isSaving ? 'Saving...' : 'Create Profile'}
              </Button>
            </div>
          </form>
        )}

        <div className="relative">
          <Input
            value={search}
            onChange={(event) => setSearch(event.target.value)}
            placeholder="Search by employee ID, name, department, position..."
            className="bg-gray-800 border-gray-700 text-white placeholder-gray-500"
          />
        </div>

        {error && <p className="text-sm text-red-400">{error}</p>}
        {isLoading && <p className="text-sm text-gray-400">Loading faculty profiles...</p>}

        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-700">
                <th className="text-left py-3 px-4 text-gray-400">Employee ID</th>
                <th className="text-left py-3 px-4 text-gray-400">Name</th>
                <th className="text-left py-3 px-4 text-gray-400">Department</th>
                <th className="text-left py-3 px-4 text-gray-400">Position</th>
                <th className="text-left py-3 px-4 text-gray-400">Specialization</th>
                <th className="text-left py-3 px-4 text-gray-400">Hire Date</th>
                <th className="text-center py-3 px-4 text-gray-400">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredProfiles.map((profile) => (
                <tr key={profile.id} className="border-b border-gray-800 hover:bg-gray-800/50">
                  <td className="py-3 px-4 text-white font-medium">{profile.employee_id}</td>
                  <td className="py-3 px-4 text-gray-300">{profile.users?.name ?? 'Unknown'}</td>
                  {editingId === profile.id ? (
                    <>
                      <td className="py-3 px-4">
                        <select value={editForm.department} onChange={(e) => setEditForm((p) => ({ ...p, department: e.target.value }))} className="h-8 rounded-md border border-gray-600 bg-gray-700 px-2 text-sm text-white">
                          {departments.map((dept) => (
                            <option key={dept} value={dept}>{dept}</option>
                          ))}
                        </select>
                      </td>
                      <td className="py-3 px-4">
                        <select value={editForm.position} onChange={(e) => setEditForm((p) => ({ ...p, position: e.target.value }))} className="h-8 rounded-md border border-gray-600 bg-gray-700 px-2 text-sm text-white">
                          {positions.map((position) => (
                            <option key={position} value={position}>{position}</option>
                          ))}
                        </select>
                      </td>
                      <td className="py-3 px-4">
                        <Input value={editForm.specialization} onChange={(e) => setEditForm((p) => ({ ...p, specialization: e.target.value }))} className="bg-gray-700 border-gray-600 text-white text-sm" />
                      </td>
                      <td className="py-3 px-4">
                        <Input type="date" value={editForm.hireDate} onChange={(e) => setEditForm((p) => ({ ...p, hireDate: e.target.value }))} className="bg-gray-700 border-gray-600 text-white text-sm" />
                      </td>
                    </>
                  ) : (
                    <>
                      <td className="py-3 px-4 text-gray-300">{profile.department}</td>
                      <td className="py-3 px-4 text-gray-300">{profile.position}</td>
                      <td className="py-3 px-4 text-gray-300">{profile.specialization || '-'}</td>
                      <td className="py-3 px-4 text-gray-300">{profile.hire_date}</td>
                    </>
                  )}
                  <td className="py-3 px-4 text-center">
                    {editingId === profile.id ? (
                      <div className="flex justify-center gap-2">
                        <Button size="sm" className="bg-blue-600 hover:bg-blue-700" onClick={onSaveEdit}><Save className="h-4 w-4" /></Button>
                        <Button size="sm" variant="outline" className="border-gray-600" onClick={onCancelEdit}><X className="h-4 w-4" /></Button>
                      </div>
                    ) : (
                      <div className="flex justify-center gap-2">
                        <Button size="sm" variant="outline" className="border-blue-600 text-blue-400 hover:text-blue-300" onClick={() => onStartEdit(profile)}><Edit className="h-4 w-4" /></Button>
                        <Button size="sm" variant="outline" className="border-red-600 text-red-400 hover:text-red-300" onClick={() => onDeleteProfile(profile.id)}><Trash2 className="h-4 w-4" /></Button>
                      </div>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {filteredProfiles.length === 0 && !isLoading && (
          <div className="text-center py-8">
            <p className="text-gray-500">No faculty profiles found.</p>
          </div>
        )}
      </CardContent>
    </Card>
  )
}
