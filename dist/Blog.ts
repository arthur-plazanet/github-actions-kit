import type { Tag } from './Tag.js'

export interface Blog {
  id: string
  slug: string
  title: string
  description: string
  body: string
  tags: Tag[]
  createdAt: string | undefined
  updatedAt: string | undefined
}
