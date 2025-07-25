// Tool-bezogene Typen für das PLMS
export interface Tool {
  id: string;
  name: string;
  description?: string;
  serialNumber: string;
  category: ToolCategory;
  status: ToolStatus;
  location?: string;
  assignedTo?: string;
  createdAt: Date;
  updatedAt: Date;
}

export enum ToolCategory {
  MECHANICAL = 'mechanical',
  ELECTRICAL = 'electrical',
  DIAGNOSTIC = 'diagnostic',
  SAFETY = 'safety',
  SPECIALTY = 'specialty'
}

export enum ToolStatus {
  AVAILABLE = 'available',
  IN_USE = 'in_use',
  MAINTENANCE = 'maintenance',
  RETIRED = 'retired'
}

export interface User {
  id: string;
  name: string;
  email: string;
  department: string;
  role: UserRole;
}

export enum UserRole {
  ADMIN = 'admin',
  MANAGER = 'manager',
  TECHNICIAN = 'technician',
  USER = 'user'
}