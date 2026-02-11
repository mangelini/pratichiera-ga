package com.pratichiera.pratichieraga.service;

import com.pratichiera.pratichieraga.model.OrderEntity;
import com.pratichiera.pratichieraga.model.OrderItemEntity;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {

    private final JavaMailSender emailSender;

    @Value("${app.admin.email}")
    private String adminEmail;

    @Value("${spring.mail.username:noreply@pratichiera.com}")
    private String fromEmail;

    public void sendOrderConfirmation(OrderEntity order) {
        if (adminEmail == null || adminEmail.isBlank()) {
            log.warn("Admin email is not configured. Skipping email sending.");
            return;
        }

        try {
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(adminEmail);
            helper.setSubject("Nuovo Ordine da " + order.getUser().getUsername());

            String htmlContent = buildOrderEmailContent(order);
            helper.setText(htmlContent, true);

            emailSender.send(message);
            log.info("Order confirmation email sent to {}", adminEmail);

        } catch (MessagingException e) {
            log.error("Failed to send order confirmation email", e);
            // We do not throw exception to avoid rolling back the order transaction just
            // because email failed?
            // Or maybe we should log it and have a retry mechanism. For now, just log
            // error.
        }
    }

    private String buildOrderEmailContent(OrderEntity order) {
        StringBuilder html = new StringBuilder();
        html.append("<html><body>");
        html.append("<h2>Nuovo Ordine Ricevuto</h2>");
        html.append("<p><strong>Utente:</strong> ").append(order.getUser().getUsername()).append("</p>");
        html.append("<p><strong>Data:</strong> ").append(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                .withZone(ZoneId.systemDefault()).format(order.getCreatedDate())).append("</p>");

        html.append("<h3>Dettaglio Ordine</h3>");
        html.append(
                "<table border='1' cellpadding='5' cellspacing='0' style='border-collapse: collapse; width: 100%;'>");
        html.append("<tr style='background-color: #f2f2f2;'>");
        html.append("<th>Prodotto</th><th>Confezione</th><th>Prezzo/Kg</th><th>Quantità</th><th>Totale (Stimato)</th>");
        html.append("</tr>");

        BigDecimal grandTotal = BigDecimal.ZERO;

        for (OrderItemEntity item : order.getItems()) {
            BigDecimal itemTotal = item.getTotalPrice();
            grandTotal = grandTotal.add(itemTotal);

            html.append("<tr>");
            html.append("<td>").append(item.getProductName()).append("</td>");
            html.append("<td>").append(item.getPackaging() != null ? item.getPackaging() : "").append("</td>");
            html.append("<td>€ ").append(item.getPricePerKg()).append("</td>");
            html.append("<td>").append(item.getQuantity()).append("</td>");
            html.append("<td>€ ").append(itemTotal).append("</td>");
            html.append("</tr>");
        }

        html.append("<tr>");
        html.append("<td colspan='4' style='text-align: right;'><strong>Totale Stimato:</strong></td>");
        html.append("<td><strong>€ ").append(grandTotal).append("</strong></td>");
        html.append("</tr>");
        html.append("</table>");

        html.append("</body></html>");
        return html.toString();
    }
}
