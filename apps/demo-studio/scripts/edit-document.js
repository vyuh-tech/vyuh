/**
 * Reference: https://www.sanity.io/guides/edit-document
 *
 * Convenient way to edit a document in your $EDITOR.
 * Usage: `node scripts/editDocument.js <documentId>`
 */
const {spawn} = require('child_process')

const [documentId] = process.argv.slice(2)

if (!documentId) {
  throw new Error('No document id was provided.')
}

spawn('sanity', ['documents', 'create', '--id', documentId, '--replace'], {
  cwd: process.cwd(),
  stdio: 'inherit',
  shell: true,
})
