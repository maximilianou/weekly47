import React from 'react';

const sec = [
  { h: 'One Section' },
  { h: 'Two Sections' },
  { h: 'Three Sections' },
  
];
const art = [
  { h: 'First Article', p: 'the key valuable content'},
  { h: 'Second Article', p: 'the key valuable content'},
  { h: 'Third Article', p: 'the key valuable content'},
];

function App() {
  return (
    <main>
      <header>Blog Title</header>
      { sec.map( se => (
          <section>        
            <h2>{se.h}</h2>
              { art.map( ar => (
                <article>
                  <h3>{ar.h}</h3>
                  <p>{ar.p}</p>
                </article>
              ), '')
              }
          </section>
      ))
      }
      <footer>The author</footer>
    </main>
  );
}

export default App;
