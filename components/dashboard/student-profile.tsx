'use client'

import { Card } from '@/components/ui/card'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'

interface StudentProfileProps {
  student?: {
    name?: string
    email?: string
    systemId?: string
  }
  profile?: {
    student_number?: string
    program?: string
    year_level?: number | null
    gpa?: number | null
    enrollment_status?: string
  } | null
}

export function StudentProfile({ student, profile }: StudentProfileProps) {
  const initials = (student?.name ?? 'Student')
    .split(' ')
    .map((namePart) => namePart[0] ?? '')
    .join('')
    .slice(0, 2)
    .toUpperCase()

  return (
    <Card className="p-6">
      <div className="flex flex-col items-center text-center gap-4">
        <Avatar className="h-16 w-16">
          <AvatarFallback className="bg-primary text-primary-foreground text-lg font-bold">
            {initials}
          </AvatarFallback>
        </Avatar>

        <div>
          <h2 className="text-xl font-bold text-foreground">{student?.name ?? 'Student'}</h2>
          <p className="text-sm text-muted-foreground">{profile?.student_number ?? student?.systemId ?? 'N/A'}</p>
        </div>

        <div className="w-full space-y-3 pt-4 border-t border-border">
          <div className="text-left">
            <p className="text-xs font-semibold text-muted-foreground uppercase">Program</p>
            <p className="text-sm text-foreground">{profile?.program ?? 'N/A'}</p>
          </div>

          <div className="text-left">
            <p className="text-xs font-semibold text-muted-foreground uppercase">Year Level</p>
            <p className="text-sm text-foreground">{profile?.year_level ? `${profile.year_level}${profile.year_level === 1 ? 'st' : profile.year_level === 2 ? 'nd' : profile.year_level === 3 ? 'rd' : 'th'} Year` : 'N/A'}</p>
          </div>

          <div className="text-left">
            <p className="text-xs font-semibold text-muted-foreground uppercase">GPA</p>
            <p className="text-sm text-foreground">{profile?.gpa?.toFixed(2) ?? 'N/A'}</p>
          </div>

          <div className="text-left">
            <p className="text-xs font-semibold text-muted-foreground uppercase">Enrollment Status</p>
            <p className="text-sm text-foreground">{profile?.enrollment_status ?? 'N/A'}</p>
          </div>

          <div className="text-left">
            <p className="text-xs font-semibold text-muted-foreground uppercase">Email</p>
            <p className="text-sm text-foreground break-all">{student?.email ?? 'N/A'}</p>
          </div>
        </div>
      </div>
    </Card>
  )
}
