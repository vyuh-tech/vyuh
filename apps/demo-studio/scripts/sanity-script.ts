/**
 * THIS SCRIPT DELETES DATA!
 *
 * To use this script:
 * 1. Put this script in your studio-folder
 * 2. Write a GROQ filter that outputs the documents you want to delete
 * 3. Run `sanity dataset export` to backup your dataset before deleting a bunch of documents
 * 4. Run `sanity exec deleteDocsByFilter.js --with-user-token` to delete the documents
 *
 */

import { getCliClient } from 'sanity/cli';
import { customAlphabet } from 'nanoid';
import { sampleSize, random } from 'lodash-es';

const nanoid = customAlphabet('0123456789abcdef', 12);

const client = getCliClient({ apiVersion: '2024-10-01' });

const docs = [
  '08ca6cd6-17a5-4bb5-9271-d07faa0dd74e',
  '1924a310-b55c-484a-9cb6-44d70bc604ce',
  '1b069397-1a3f-40cd-b5ab-fce58b908c9f',
  '2c10d90c-6c4d-4b23-85e7-737b29281a35',
  '2d6eecfc-0513-45b4-a3e4-3656753e7875',
  '37ff126d-92e6-4e17-849d-ebf97e195a64',
  '39e549be-600f-4f1d-a482-890f085df600',
  '5a5ea3c0-8803-41c7-b973-0b8a464f30c3',
  '6dd74f1a-2cbf-418e-b389-a940ec7b1637',
  'drafts.08ca6cd6-17a5-4bb5-9271-d07faa0dd74e',
  'drafts.770e01a8-3ede-4d57-a2dc-1817d7ea9c67',
  'e04a88e1-ae64-4205-82fa-fa7e2544d365',
];

function createReferences(idList: string[]) {
  const selection = sampleSize(idList, random(1, 3));

  return selection.map((id) => ({
    _key: nanoid(),
    _type: 'reference',
    _ref: id,
  }));
}

(async () => {
  const list = await client.fetch('*[_type == "conf.track"]{_id}._id');
  const txn = client.transaction();
  docs.forEach((id) => {
    const refList = createReferences(list);

    const patch = client.patch(id).set({ tracks: refList });
    txn.patch(patch);
  });

  txn.commit().then(console.log).catch(console.error);
})();
