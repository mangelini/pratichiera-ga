@import com.pratichiera.pratichieraga.model.PriceListEntity
@import com.pratichiera.pratichieraga.model.PriceListItemEntity
@import com.pratichiera.pratichieraga.model.UserEntity

@param PriceListEntity priceList
@param UserEntity user
@param Boolean success = false

<!DOCTYPE html>
<html lang="it" data-theme="light">
<head>
    <meta charset="utf-8">
    <title>Ordine - ${user.getUsername()}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
    <link rel="stylesheet" href="/css/custom.css">
</head>
<body>
<header class="container">
    <nav>
        <ul><li><strong>Pratichiera Gruppi Acquisto</strong></li></ul>
        <ul>
            <li>Benvenuto, ${user.getUsername()}</li>
            <li><form action="/logout" method="post"><button class="outline secondary">Esci</button></form></li>
        </ul>
    </nav>
</header>

<main class="container">
    @if(success)
        <article style="background-color: #e8f5e9; color: #1b5e20;">
            ✅ Ordine salvato con successo!
        </article>
    @endif

    @if(priceList == null)
        <article>
            <h3>Nessun listino attivo</h3>
            <p>Non c'è ancora un listino prezzi disponibile per questo mese. Attendi la comunicazione dell'amministratore.</p>
        </article>
    @else
        <h2>Listino Mese: ${String.valueOf(priceList.getReferenceMonth())}</h2>
        <p>Compila le quantità desiderate e clicca su "Salva Ordine".</p>

        <form action="/orders/submit" method="post">
            <div style="overflow-x: auto;">
                <table class="striped">
                    <thead>
                    <tr>
                        <th>Prodotto</th>
                        <th>Confezione</th>
                        <th>Prezzo/Kg</th>
                        <th>Note</th>
                        <th style="width: 140px;">Quantità</th>
                    </tr>
                    </thead>
                    <tbody>
                    @for(PriceListItemEntity item : priceList.getItems())
                        <tr>
                            <td><strong>${item.getProductName()}</strong></td>
                            <td>${item.getPackaging()}</td>
                            <td>€ ${item.getPricePerKg()}</td>
                            <td><small>${item.getNotes()}</small></td>
                            <td>
                                <input type="number"
                                       name="qty_${item.getId()}"
                                       value="${item.getQuantity()}"
                                       min="0" step="1">
                            </td>
                        </tr>
                    @endfor
                    </tbody>
                </table>
            </div>
            <footer>
                <button type="submit">💾 Invia Ordine</button>
            </footer>
        </form>
    @endif
</main>
</body>
</html>