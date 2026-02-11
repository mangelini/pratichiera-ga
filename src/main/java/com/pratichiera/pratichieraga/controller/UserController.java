package com.pratichiera.pratichieraga.controller;

import com.pratichiera.pratichieraga.model.UserEntity;
import com.pratichiera.pratichieraga.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class UserController {
    private final UserRepository userRepository;

    @GetMapping("/login")
    public String loginPage(
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout,
            Model model
    ) {
        if (error != null) model.addAttribute("error", "Invalid username or password");
        if (logout != null) model.addAttribute("logout", "true");
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(String username, String password, HttpSession session) {
        Optional<UserEntity> userEntity = userRepository.findByUsername(username);

        if (userEntity.isPresent()) {
            UserEntity user = userEntity.get();
            if (user.getPassword().equals(password)) {
                session.setAttribute("user_id", user.getId());
                session.setAttribute("is_admin", user.getIsAdmin());
                return "redirect:/";
            }
        }

        return "redirect:/login?error";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login?logout";
    }
}
