@import com.pratichiera.pratichieraga.model.OrderEntity
@import com.pratichiera.pratichieraga.model.OrderItemEntity
@import java.util.List
@import java.time.format.DateTimeFormatter
@import java.time.ZoneId

@param List<OrderEntity> orders

<!DOCTYPE html>
<html lang="it" data-theme="light">
<head>
    <meta charset="utf-8">
    <title>Ordini - Pannello Amministratore</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
    <link rel="stylesheet" href="/css/custom.css">
    <style>
        details {
            margin-bottom: 0;
            border-bottom: 1px solid var(--pico-table-border-color);
        }
        details summary {
            padding: var(--pico-spacing);
        }
        details[open] summary {
            margin-bottom: var(--pico-spacing);
        }
    </style>
</head>
<body>
<main class="container">
    <nav>
        <ul>
            <li><strong><a href="/admin/dashboard" class="secondary">Pannello Amministratore</a></strong></li>
        </ul>
        <ul>
            <li><h1>Ordini Ricevuti</h1></li>
        </ul>
        <ul>
             <li><form action="/logout" method="post"><button class="outline secondary">Esci</button></form></li>
        </ul>
    </nav>

    <hr>

    @if(orders.isEmpty())
        <article>
            <h3>Nessun ordine presente</h3>
            <p>Non sono stati ancora ricevuti ordini.</p>
        </article>
    @else
        <div style="overflow-x: auto;">
            <table class="striped">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Data</th>
                    <th>Utente</th>
                    <th>Totale Stimato</th>
                    <th>Dettagli</th>
                </tr>
                </thead>
                <tbody>
                @for(OrderEntity order : orders)
                   !{var totalPrice = java.math.BigDecimal.ZERO;}
                   @for(OrderItemEntity item : order.getItems())
                        !{totalPrice = totalPrice.add(item.getTotalPrice());}
                   @endfor

                    <tr>
                        <td>#${order.getId()}</td>
                        <td>${DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").withZone(ZoneId.systemDefault()).format(order.getCreatedDate())}</td>
                        <td>${order.getUser().getUsername()}</td>
                        <td>€ ${totalPrice}</td>
                        <td>
                            <details>
                                <summary>Vedi Prodotti (${order.getItems().size()})</summary>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Prodotto</th>
                                            <th>Conf.</th>
                                            <th>Prezzo/Kg</th>
                                            <th>Qtà</th>
                                            <th>Totale</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @for(OrderItemEntity item : order.getItems())
                                            <tr>
                                                <td>${item.getProductName()}</td>
                                                <td>${item.getPackaging()}</td>
                                                <td>€ ${item.getPricePerKg()}</td>
                                                <td>${item.getQuantity()}</td>
                                                <td>€ ${item.getTotalPrice()}</td>
                                            </tr>
                                        @endfor
                                    </tbody>
                                </table>
                            </details>
                        </td>
                    </tr>
                @endfor
                </tbody>
            </table>
        </div>
    @endif
</main>
</body>
</html>
