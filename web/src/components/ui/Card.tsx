import type { ReactNode } from 'react'

interface CardProps {
  children: ReactNode
  className?: string
  padding?: string
}

/** White rounded surface card with the standard soft shadow. */
export function Card({ children, className = '', padding = 'p-3.5' }: CardProps) {
  return (
    <div
      className={`rounded-[18px] bg-surface shadow-[var(--shadow-card)] ring-1 ring-border ${padding} ${className}`}
    >
      {children}
    </div>
  )
}
