import { FaRegCircleUser as Icon } from 'react-icons/fa6';
import { defineField } from 'sanity';

export let authUserCardLayout = {
  type: 'object',
  name: 'firebaseAuth.card.layout.user',
  title: 'Auth User',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      description: (
        <div>
          The following actions are invoked after completion:
          <ul>
            <li>
              Login: <code>action</code> (Action)
            </li>
            <li>
              Logout: <code>secondaryAction</code> (Secondary Action)
            </li>
          </ul>
        </div>
      ),
      type: 'string',
      initialValue: 'Auth User',
      readOnly: true,
    }),
  ],
  preview: {
    prepare: () => {
      return {
        title: 'Auth User',
      };
    },
  },
};
