// Utility-Funktionen für das PLMS

export const formatDate = (date: Date): string => {
  return new Intl.DateTimeFormat('de-DE', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(date)
}

export const generateId = (): string => {
  return Math.random().toString(36).substr(2, 9)
}

export const formatToolStatus = (status: string): string => {
  const statusMap: { [key: string]: string } = {
    available: 'Verfügbar',
    in_use: 'In Verwendung',
    maintenance: 'Wartung',
    retired: 'Ausgemustert'
  }
  return statusMap[status] || status
}

export const formatToolCategory = (category: string): string => {
  const categoryMap: { [key: string]: string } = {
    mechanical: 'Mechanisch',
    electrical: 'Elektrisch',
    diagnostic: 'Diagnose',
    safety: 'Sicherheit',
    specialty: 'Spezial'
  }
  return categoryMap[category] || category
}