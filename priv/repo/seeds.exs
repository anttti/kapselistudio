# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kapselistudio.Repo.insert!(%Kapselistudio.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto.Query, only: [from: 2]

Kapselistudio.Repo.insert!(%Kapselistudio.Media.Podcast{
  name: "Webbidevaus.fi",
  slug: "webbidevaus",
  url: "https://webbidevaus.fi",
  description: "Devausta webistä ja webbisen devausta.",
  type: "episodic",
  keywords: "html, css, javascript",
  owner_name: "Antti Mattila",
  owner_email: "foo@bar.com",
  main_category: "Technology"
})

podcast_1_id =
  Kapselistudio.Repo.one!(from p in "podcasts", where: p.name == "Webbidevaus.fi", select: p.id)

shownotes = """
One morning, when Gregor Samsa woke from troubled dreams, he found himself *transformed* in his bed into a horrible [vermin](http://en.wikipedia.org/wiki/Vermin "Wikipedia Vermin"). He lay on his armour-like back, and if he lifted his head a little he could see his brown belly, slightly domed and divided by arches into stiff sections. The bedding was hardly able to cover **strong** it and seemed ready to slide off any moment. His many legs, pitifully thin compared with the size of the rest of him, link waved abouthelplessly as he looked. “What's happened to me?” he thought. It wasn't a dream. His room, a proper human room although a little too small, lay peacefully between its four familiar walls.

## The bedding was hardly able to cover it

It showed a lady fitted out with a fur hat and fur boa who sat upright, raising a heavy fur muff that covered the whole of her lower arm towards the viewer a solid fur muff into which her entire forearm disappeared..

### Things we know about Gregor's sleeping habits.

- He always slept on his right side.
- He has to get up early (to start another dreadful day).
- He has a drawer and a alarm clock next to his bed.
- His mother calls him when he gets up to late.

It was very easy to throw aside the blanket. He needed only to push himself up a little, and it fell by itself. But to continue was difficult, particularly because he was so unusually wide. He needed arms and hands to push himself upright. Instead of these, however, he had only many small limbs which were incessantly moving with very different motions and which, in addition, he was unable to control. If he wanted to bend one of them, then it was the first to extend itself, and if he finally succeeded doing with this limb what he wanted, in the meantime all the others, as if left free, moved around in an excessively painful agitation. "But I must not stay in bed uselessly," said Gregor to himself.

> At first he wanted to get off the bed with the lower part of his body, but this lower part (which he incidentally had not yet looked at and which he also couldn't picture clearly) proved itself too difficult to move. The attempt went so slowly. When, having become almost frantic, he finally hurled himself forward with all his force and without thinking, he chose his direction incorrectly, and he hit the lower bedpost hard. The violent pain he felt revealed to him that the lower part of his body was at the moment probably the most sensitive.

Thus, he tried to get his upper body out of the bed first and turned his head carefully toward the edge of the bed. He managed to do this easily, and in spite of its width and weight his body mass at last slowly followed the turning of his head. But as he finally raised his head outside the bed in the open air, he became anxious about moving forward any further in this manner, for if he allowed himself eventually to fall by this process, it would take a miracle to prevent his head from getting injured. And at all costs he must not lose consciousness right now. He preferred to remain in bed.

#### First five selected publications in English

1. The Castle
2. The Great Wall of China
3. The Trial
4. America
5. The Diaries Of Franz Kafka
"""

titles = [Ensimmäinen: 1, Toinen: 2, Kolmas: 3, Neljäs: 4, Viides: 5]

for {title, index} <- titles,
    do:
      Kapselistudio.Repo.insert!(%Kapselistudio.Media.Episode{
        title: "#{title} jakso",
        number: index,
        podcast_id: podcast_1_id,
        duration: 60,
        url: "http://jakso.com/jakso.mp3",
        shownotes: shownotes,
        status: if(index != 5, do: "PUBLISHED", else: "DRAFT"),
        published_at: if(index != 5, do: ~U[2021-05-18 21:25:06Z], else: nil)
      })

Kapselistudio.Repo.insert!(%Kapselistudio.Accounts.User{
  email: "test@test.com",
  hashed_password: Bcrypt.hash_pwd_salt("test"),
  confirmed_at: ~N[2021-01-01 00:00:00]
})
