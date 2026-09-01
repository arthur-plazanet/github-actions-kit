import type { Tag } from './Tag.js'

export interface Snippet {
  id: string
  slug: string
  title: string
  description: string
  language: string
  code: string
  tags: Tag[]
  createdAt: string | undefined
  updatedAt: string | undefined
}
