@import com.pratichiera.pratichieraga.model.UserEntity
@import com.pratichiera.pratichieraga.model.PriceListEntity
@import java.util.List

@param List<UserEntity> users
@param List<PriceListEntity> priceLists

<!DOCTYPE html>
<html lang="it" data-theme="light">
<head>
    <meta charset="utf-8">
    <title>Pannello Amministratore</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
    <link rel="stylesheet" href="/css/custom.css">
</head>
<body>
<main class="container">
    <nav>
        <ul>
            <li><h1>Amministrazione Caseificio Pratichiera</h1></li>
        </ul>
        <ul>
            <li><a href="/admin/orders" role="button" class="contrast">📦 Vedi Ordini</a></li>
            <li><form action="/logout" method="post" style="margin: 0;"><button class="outline secondary">Esci</button></form></li>
        </ul>
    </nav>

    <div class="grid">
        <article>
            <header><strong>Nuovo Gruppo Acquisto</strong></header>
            <form action="/admin/users" method="post">
                <label>Username
                    <input type="text" name="username" required>
                </label>
                <label>Password
                    <input type="text" name="password" required>
                </label>
                <button type="submit">Crea Utente</button>
            </form>
        </article>

        <article>
            <header><strong>Nuovo Listino Mensile</strong></header>
            <form action="/admin/pricelists" method="post">
                <label>Nome Listino
                    <input type="text" name="name" placeholder="Es. Febbraio 2026" required>
                </label>
                <label>Mese di Riferimento
                    <input type="month" name="month" required>
                </label>
                <button type="submit">Crea e Modifica Listino</button>
            </form>
        </article>
    </div>

    <hr>

    <h3>Listini Presenti</h3>
    <table class="striped">
        <thead>
        <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Mese</th>
            <th>Gruppi Assegnati</th>
            <th>Azioni</th>
        </tr>
        </thead>
        <tbody>
        @for(PriceListEntity pl : priceLists)
            <tr>
                <td>${pl.getId()}</td>
                <td>${pl.getName()}</td>
                <td>${String.valueOf(pl.getReferenceMonth())}</td>
                <td>
                    @if(pl.getUsers().isEmpty())
                        <small><em>Nessuno</em></small>
                    @else
                        ${pl.getUsers().stream().map(u -> u.getUsername()).collect(java.util.stream.Collectors.joining(", "))}
                    @endif
                </td>
                <td>
                    <div role="group">
                        <a href="/admin/pricelists/${pl.getId()}" role="button" class="outline">Modifica</a>
                        <form action="/admin/pricelists/${pl.getId()}/delete" method="post" onsubmit="return confirm('Sei sicuro di voler eliminare questo listino?');" style="margin-bottom: 0;">
                            <button type="submit" class="outline secondary">Elimina</button>
                        </form>
                    </div>
                </td>
            </tr>
        @endfor
        </tbody>
    </table>
</main>
</body>
</html>