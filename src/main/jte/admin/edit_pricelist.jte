@import com.pratichiera.pratichieraga.model.PriceListEntity
@import com.pratichiera.pratichieraga.model.PriceListItemEntity
@import com.pratichiera.pratichieraga.model.UserEntity

@param PriceListEntity priceList
@param Iterable<UserEntity> allUsers

<!DOCTYPE html>
<html lang="it" data-theme="light">
<head>
    <title>Modifica Listino</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
    <link rel="stylesheet" href="/css/custom.css">
    <style>
        .chip-list {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        .chip {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background: var(--pico-primary-background);
            color: var(--pico-primary-inverse);
            padding: 0.3rem 0.7rem;
            border-radius: 2rem;
            font-size: 0.85rem;
        }
        .chip form {
            margin: 0;
            display: inline;
        }
        .chip button {
            background: none;
            border: none;
            color: var(--pico-primary-inverse);
            cursor: pointer;
            padding: 0;
            margin: 0;
            font-size: 1rem;
            line-height: 1;
            width: auto;
            opacity: 0.7;
        }
        .chip button:hover {
            opacity: 1;
        }
        .add-user-row {
            display: flex;
            gap: 0.5rem;
            align-items: flex-end;
        }
        .add-user-row select {
            margin-bottom: 0;
        }
        .add-user-row button {
            white-space: nowrap;
            margin-bottom: 0;
        }
    </style>
</head>
<body>
<main class="container">
    <header>
        <hgroup>
            <h2>Modifica Listino: ${priceList.getName()}</h2>
            <p>Mese: ${String.valueOf(priceList.getReferenceMonth())}</p>
        </hgroup>
        <div>
            <a href="/admin" role="button" class="secondary outline">Torna Indietro</a>
        </div>
    </header>

    <article>
        <header><strong>Gruppi Acquisto Assegnati</strong></header>

        @if(priceList.getUsers().isEmpty())
            <p><em>Nessun gruppo assegnato.</em></p>
        @else
            <div class="chip-list">
                @for(UserEntity u : priceList.getUsers())
                    <span class="chip">
                        ${u.getUsername()}
                        <form action="/admin/pricelists/${priceList.getId()}/users/${u.getId()}/remove" method="post">
                            <button type="submit" title="Rimuovi">✕</button>
                        </form>
                    </span>
                @endfor
            </div>
        @endif

        <form action="/admin/pricelists/${priceList.getId()}/users/add" method="post">
            <div class="add-user-row">
                <select name="userId" id="userSelect" required>
                    <option value="" disabled selected>Cerca gruppo...</option>
                    @for(UserEntity u : allUsers)
                        @if(!u.getIsAdmin() && !priceList.getUsers().contains(u))
                            <option value="${u.getId()}">${u.getUsername()}</option>
                        @endif
                    @endfor
                </select>
                <button type="submit">+ Aggiungi</button>
            </div>
        </form>
    </article>

    <article>
        <header>Aggiungi Prodotto</header>
        <form action="/admin/pricelists/${priceList.getId()}/items" method="post">
            <div class="grid">
                <label>Nome Prodotto
                    <input type="text" name="productName" placeholder="Es. Parmigiano 30 mesi" required>
                </label>
                <label>Confezione
                    <input type="text" name="packaging" placeholder="Es. Punta 1kg">
                </label>
            </div>
            <div class="grid">
                <label>Prezzo al Kg (€)
                    <input type="number" step="0.01" name="price" required>
                </label>
                <label>Note
                    <input type="text" name="notes">
                </label>
            </div>
            <button type="submit">Aggiungi Riga</button>
        </form>
    </article>

    <h3>Prodotti in Listino</h3>
    <table>
        <thead>
        <tr>
            <th>Prodotto</th>
            <th>Confezione</th>
            <th>Prezzo/Kg</th>
            <th>Note</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        @for(PriceListItemEntity item : priceList.getItems())
            <tr>
                <td>${item.getProductName()}</td>
                <td>${item.getPackaging()}</td>
                <td>€ ${item.getPricePerKg()}</td>
                <td>${item.getNotes()}</td>
                <td>
                    <form action="/admin/items/${item.getId()}/delete" method="post" style="margin:0;">
                        <button type="submit" class="contrast outline" style="padding: 5px 10px; font-size: 0.8rem;">Rimuovi</button>
                    </form>
                </td>
            </tr>
        @endfor
        </tbody>
    </table>
</main>

<script>
    // Simple client-side filtering for the user dropdown
    const select = document.getElementById('userSelect');
    if (select && select.options.length > 10) {
        const wrapper = select.parentElement;
        const searchInput = document.createElement('input');
        searchInput.type = 'search';
        searchInput.placeholder = 'Filtra gruppi...';
        searchInput.style.marginBottom = '0.5rem';
        wrapper.insertBefore(searchInput, select);

        const allOptions = Array.from(select.options).slice(1); // skip the placeholder

        searchInput.addEventListener('input', () => {
            const query = searchInput.value.toLowerCase();
            select.innerHTML = '';
            const placeholder = document.createElement('option');
            placeholder.value = '';
            placeholder.disabled = true;
            placeholder.selected = true;
            placeholder.textContent = 'Cerca gruppo...';
            select.appendChild(placeholder);

            allOptions.forEach(opt => {
                if (opt.textContent.toLowerCase().includes(query)) {
                    select.appendChild(opt.cloneNode(true));
                }
            });
        });
    }
</script>
</body>
</html>