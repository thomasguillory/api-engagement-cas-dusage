# MVP

## Implémentation

Dans ce dossier, vous trouverez le MVP demandé.

- La stack est la même que pour le projet actuel : node, express, typescript, prisma
- Le modèle Prisma a été réduit au minimum pour ce MVP
- Pour tester le MVP :
  - Installer les dépendances : `npm install`
  - Exécuter le serveur : `npm run dev`
  - Checker les datas dans la base (la base sqlite est commitée) : `npx prisma studio`
  - Appeler l'API, par exemple : `curl -XGET http://localhost:3000/r/impression/3d78028b-35e7-4a8d-8b7c-61a3d2af0644/6ff2fa8d-dc31-4cac-a718-9b1de606dd22`

## Question Bonus

> Donne une raison pour laquelle dans le lien de la candidature, il est utile de préciser l’identifiant de la

On parle ici de l'appel suivant : `GET - /r/apply?view={token}&mission={missionId}&publisher={publisherId}`

Prenons pour exemple le scénario suivant :

- L'utilisateur clique sur un lien de redirection qui le fait arriver sur une annonce pour une mission A d'un partenaire annonceur - un token est généré et stocké dans les cookies sur ce site
- Tout en restant sur le même site, l'utilisateur change d'annonce et visite une annonce pour une mission B qui se trouve également provenir de l'API Engagement
- L'utilisateur postule et le lien de tracking est appelé

==> Le token seul ne permet pas de présumer de quelle mission est concernée. Le missionId est donc nécessaire.
