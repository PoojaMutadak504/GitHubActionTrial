package com.testmonster.tests;

import java.net.MalformedURLException;

import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.testmonster.commons.Library;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileElement;

public class server140323 {
	public AppiumDriver<MobileElement> driver;
	public Library lib;

	@BeforeClass
	public void setup() throws MalformedURLException {
		lib = new Library("Test Started");
		driver = lib.launchDriver();

	}

	@Test
	public void server140323Test() throws Exception {
                  lib.findMobileElement("id:nextButton");

	}

	@AfterClass
	public void afterClass() {
		lib.quitBrowser();
	}

}
