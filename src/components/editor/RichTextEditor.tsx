import { useEditor, EditorContent } from '@tiptap/react'
import { useEffect } from 'react'
import StarterKit from '@tiptap/starter-kit'
import { Placeholder } from '@tiptap/extension-placeholder'
import { Link } from '@tiptap/extension-link'
import { Image } from '@tiptap/extension-image'
import { Table } from '@tiptap/extension-table'
import { TableRow } from '@tiptap/extension-table-row'
import { TableCell } from '@tiptap/extension-table-cell'
import { TableHeader } from '@tiptap/extension-table-header'
import { TextAlign } from '@tiptap/extension-text-align'
import { Color } from '@tiptap/extension-color'
import { TextStyle } from '@tiptap/extension-text-style'
import { Highlight } from '@tiptap/extension-highlight'
import { Underline } from '@tiptap/extension-underline'
import './editor.css'
import {
  Bold,
  Italic,
  Underline as UnderlineIcon,
  Strikethrough,
  Code,
  Heading1,
  Heading2,
  Heading3,
  List,
  ListOrdered,
  Quote,
  Undo,
  Redo,
  Link as LinkIcon,
  Image as ImageIcon,
  Table as TableIcon,
  AlignLeft,
  AlignCenter,
  AlignRight,
  AlignJustify,
  Palette,
  Highlighter,
} from 'lucide-react'

interface RichTextEditorProps {
  content: string
  onChange: (content: string) => void
  placeholder?: string
  className?: string
}

export function RichTextEditor({ content, onChange, placeholder, className }: RichTextEditorProps) {
  const editor = useEditor({
    extensions: [
      StarterKit.configure({
        heading: {
          levels: [1, 2, 3],
        },
      }),
      Placeholder.configure({
        placeholder: placeholder || '내용을 입력하세요...',
      }),
      Link.configure({
        openOnClick: false,
        HTMLAttributes: {
          class: 'text-blue-600 underline cursor-pointer',
        },
      }),
      Image.configure({
        HTMLAttributes: {
          class: 'max-w-full h-auto rounded-lg',
        },
        inline: true,
      }),
      Table.configure({
        resizable: true,
        HTMLAttributes: {
          class: 'border-collapse border border-gray-300 my-4',
        },
      }),
      TableRow,
      TableHeader,
      TableCell,
      TextAlign.configure({
        types: ['heading', 'paragraph'],
      }),
      Color,
      TextStyle,
      Highlight.configure({
        multicolor: true,
      }),
      Underline,
    ],
    content: content || '',
    onUpdate: ({ editor }) => {
      onChange(editor.getHTML())
    },
    editorProps: {
      attributes: {
        class: 'min-h-[300px] p-4 focus:outline-none',
      },
    },
  })

  // content가 변경되면 에디터 내용 업데이트 (외부에서 content가 변경될 때만)
  useEffect(() => {
    if (editor && content !== undefined && content !== editor.getHTML()) {
      const currentContent = editor.getHTML()
      if (currentContent !== content) {
        editor.commands.setContent(content || '')
      }
    }
  }, [content])

  if (!editor) {
    return (
      <div className="border border-gray-300 rounded-lg p-4 min-h-[300px] flex items-center justify-center">
        <div className="text-gray-500">에디터를 로딩하는 중...</div>
      </div>
    )
  }

  const addImage = () => {
    const url = window.prompt('이미지 URL을 입력하세요:')
    if (url) {
      editor.chain().focus().setImage({ src: url }).run()
    }
  }

  const addLink = () => {
    const previousUrl = editor.getAttributes('link').href
    const url = window.prompt('링크 URL을 입력하세요:', previousUrl)

    if (url === null) {
      return
    }

    if (url === '') {
      editor.chain().focus().extendMarkRange('link').unsetLink().run()
      return
    }

    editor.chain().focus().extendMarkRange('link').setLink({ href: url }).run()
  }

  const addTable = () => {
    editor.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run()
  }

  const setColor = (color: string) => {
    editor.chain().focus().setColor(color).run()
  }

  const setHighlight = (color: string) => {
    editor.chain().focus().toggleHighlight({ color }).run()
  }

  return (
    <div className={`border border-gray-300 rounded-lg overflow-hidden ${className}`}>
      {/* 툴바 */}
      <div className="border-b border-gray-300 bg-gray-50 p-2 flex flex-wrap items-center gap-2">
        {/* 텍스트 스타일 */}
        <div className="flex items-center gap-1 border-r border-gray-300 pr-2">
          <button
            onClick={() => editor.chain().focus().toggleBold().run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('bold') ? 'bg-gray-300' : ''
            }`}
            title="굵게"
          >
            <Bold className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().toggleItalic().run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('italic') ? 'bg-gray-300' : ''
            }`}
            title="기울임"
          >
            <Italic className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().toggleUnderline().run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('underline') ? 'bg-gray-300' : ''
            }`}
            title="밑줄"
          >
            <UnderlineIcon className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().toggleStrike().run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('strike') ? 'bg-gray-300' : ''
            }`}
            title="취소선"
          >
            <Strikethrough className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().toggleCode().run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('code') ? 'bg-gray-300' : ''
            }`}
            title="코드"
          >
            <Code className="w-4 h-4" />
          </button>
        </div>

        {/* 제목 */}
        <div className="flex items-center gap-1 border-r border-gray-300 pr-2">
          <button
            onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('heading', { level: 1 }) ? 'bg-gray-300' : ''
            }`}
            title="제목 1"
          >
            <Heading1 className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('heading', { level: 2 }) ? 'bg-gray-300' : ''
            }`}
            title="제목 2"
          >
            <Heading2 className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().toggleHeading({ level: 3 }).run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('heading', { level: 3 }) ? 'bg-gray-300' : ''
            }`}
            title="제목 3"
          >
            <Heading3 className="w-4 h-4" />
          </button>
        </div>

        {/* 목록 */}
        <div className="flex items-center gap-1 border-r border-gray-300 pr-2">
          <button
            onClick={() => editor.chain().focus().toggleBulletList().run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('bulletList') ? 'bg-gray-300' : ''
            }`}
            title="순서 없는 목록"
          >
            <List className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().toggleOrderedList().run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('orderedList') ? 'bg-gray-300' : ''
            }`}
            title="순서 있는 목록"
          >
            <ListOrdered className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().toggleBlockquote().run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('blockquote') ? 'bg-gray-300' : ''
            }`}
            title="인용구"
          >
            <Quote className="w-4 h4" />
          </button>
        </div>

        {/* 정렬 */}
        <div className="flex items-center gap-1 border-r border-gray-300 pr-2">
          <button
            onClick={() => editor.chain().focus().setTextAlign('left').run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive({ textAlign: 'left' }) ? 'bg-gray-300' : ''
            }`}
            title="왼쪽 정렬"
          >
            <AlignLeft className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().setTextAlign('center').run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive({ textAlign: 'center' }) ? 'bg-gray-300' : ''
            }`}
            title="가운데 정렬"
          >
            <AlignCenter className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().setTextAlign('right').run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive({ textAlign: 'right' }) ? 'bg-gray-300' : ''
            }`}
            title="오른쪽 정렬"
          >
            <AlignRight className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().setTextAlign('justify').run()}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive({ textAlign: 'justify' }) ? 'bg-gray-300' : ''
            }`}
            title="양쪽 정렬"
          >
            <AlignJustify className="w-4 h-4" />
          </button>
        </div>

        {/* 색상 및 하이라이트 */}
        <div className="flex items-center gap-1 border-r border-gray-300 pr-2">
          <div className="relative group">
            <button
              className="p-2 rounded hover:bg-gray-200 transition"
              title="텍스트 색상"
            >
              <Palette className="w-4 h-4" />
            </button>
            <div className="absolute top-full left-0 mt-1 bg-white border border-gray-300 rounded-lg shadow-lg p-2 hidden group-hover:block z-10">
              <div className="grid grid-cols-6 gap-1">
                {['#000000', '#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#FF00FF', '#00FFFF', '#FFA500', '#800080', '#FFC0CB', '#A52A2A', '#808080'].map((color) => (
                  <button
                    key={color}
                    onClick={() => setColor(color)}
                    className="w-6 h-6 rounded border border-gray-300 hover:scale-110 transition"
                    style={{ backgroundColor: color }}
                    title={color}
                  />
                ))}
              </div>
            </div>
          </div>
          <div className="relative group">
            <button
              className={`p-2 rounded hover:bg-gray-200 transition ${
                editor.isActive('highlight') ? 'bg-gray-300' : ''
              }`}
              title="하이라이트"
            >
              <Highlighter className="w-4 h-4" />
            </button>
            <div className="absolute top-full left-0 mt-1 bg-white border border-gray-300 rounded-lg shadow-lg p-2 hidden group-hover:block z-10">
              <div className="grid grid-cols-6 gap-1">
                {['#FFFF00', '#00FF00', '#00FFFF', '#FF00FF', '#FFA500', '#FFC0CB'].map((color) => (
                  <button
                    key={color}
                    onClick={() => setHighlight(color)}
                    className="w-6 h-6 rounded border border-gray-300 hover:scale-110 transition"
                    style={{ backgroundColor: color }}
                    title={color}
                  />
                ))}
              </div>
            </div>
          </div>
        </div>

        {/* 링크 및 미디어 */}
        <div className="flex items-center gap-1 border-r border-gray-300 pr-2">
          <button
            onClick={addLink}
            className={`p-2 rounded hover:bg-gray-200 transition ${
              editor.isActive('link') ? 'bg-gray-300' : ''
            }`}
            title="링크 삽입"
          >
            <LinkIcon className="w-4 h-4" />
          </button>
          <button
            onClick={addImage}
            className="p-2 rounded hover:bg-gray-200 transition"
            title="이미지 삽입"
          >
            <ImageIcon className="w-4 h-4" />
          </button>
          <button
            onClick={addTable}
            className="p-2 rounded hover:bg-gray-200 transition"
            title="표 삽입"
          >
            <TableIcon className="w-4 h-4" />
          </button>
        </div>

        {/* 실행 취소/다시 실행 */}
        <div className="flex items-center gap-1">
          <button
            onClick={() => editor.chain().focus().undo().run()}
            disabled={!editor.can().undo()}
            className="p-2 rounded hover:bg-gray-200 transition disabled:opacity-50 disabled:cursor-not-allowed"
            title="실행 취소"
          >
            <Undo className="w-4 h-4" />
          </button>
          <button
            onClick={() => editor.chain().focus().redo().run()}
            disabled={!editor.can().redo()}
            className="p-2 rounded hover:bg-gray-200 transition disabled:opacity-50 disabled:cursor-not-allowed"
            title="다시 실행"
          >
            <Redo className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* 에디터 영역 */}
      <div className="bg-white min-h-[300px]">
        <EditorContent editor={editor} className="prose max-w-none" />
      </div>
    </div>
  )
}

