package com.cx.kaoyi.business.service;

import org.apache.shiro.crypto.RandomNumberGenerator;
import org.apache.shiro.crypto.SecureRandomNumberGenerator;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.cx.kaoyi.business.domain.Student;
import com.cx.kaoyi.business.domain.User;

@Service
public class PasswordHelper {

	private RandomNumberGenerator randomNumberGenerator = new SecureRandomNumberGenerator();

	@Value("${password.algorithmName}")
	private String algorithmName = "SHA-256";
	@Value("${password.hashIterations}")
	private int hashIterations = 3;

	public void setRandomNumberGenerator(RandomNumberGenerator randomNumberGenerator) {
		this.randomNumberGenerator = randomNumberGenerator;
	}

	public void setAlgorithmName(String algorithmName) {
		this.algorithmName = algorithmName;
	}

	public void setHashIterations(int hashIterations) {
		this.hashIterations = hashIterations;
	}

	public void encryptPassword(User user) {

		user.setSalt(randomNumberGenerator.nextBytes().toHex());

		String newPassword = new SimpleHash(algorithmName, user.getPassword(),
				ByteSource.Util.bytes(user.getCredentialsSalt()), hashIterations).toHex();
//		System.out.println("newPassword: " + newPassword);
		user.setPassword(newPassword);
	}

	public void encryptStudentPassword(Student student) {

		student.setSalt(randomNumberGenerator.nextBytes().toHex());

		String newPassword = new SimpleHash(algorithmName, student.getPass(),
				ByteSource.Util.bytes(student.getCredentialsSalt()), hashIterations).toHex();
		// System.out.println("newPassword: " + newPassword);
		student.setPass(newPassword);
	}
}
