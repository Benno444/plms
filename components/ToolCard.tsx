import { Tool, ToolStatus } from '@/types'

interface ToolCardProps {
  tool: Tool
}

export default function ToolCard({ tool }: ToolCardProps) {
  const getStatusColor = (status: ToolStatus) => {
    switch (status) {
      case ToolStatus.AVAILABLE:
        return 'bg-green-100 text-green-800'
      case ToolStatus.IN_USE:
        return 'bg-blue-100 text-blue-800'
      case ToolStatus.MAINTENANCE:
        return 'bg-yellow-100 text-yellow-800'
      case ToolStatus.RETIRED:
        return 'bg-red-100 text-red-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  return (
    <div className="bg-white p-4 rounded-lg shadow-md border">
      <div className="flex justify-between items-start mb-2">
        <h3 className="text-lg font-semibold text-gray-900">{tool.name}</h3>
        <span className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusColor(tool.status)}`}>
          {tool.status}
        </span>
      </div>
      
      <p className="text-gray-600 text-sm mb-2">{tool.description}</p>
      
      <div className="text-sm text-gray-500">
        <p><strong>Seriennummer:</strong> {tool.serialNumber}</p>
        <p><strong>Kategorie:</strong> {tool.category}</p>
        {tool.location && <p><strong>Standort:</strong> {tool.location}</p>}
        {tool.assignedTo && <p><strong>Zugewiesen an:</strong> {tool.assignedTo}</p>}
      </div>
    </div>
  )
}