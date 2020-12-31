package com.tec.logotec.compilador.ast;

import com.tec.logotec.compilador.window.CompilerState;

import java.awt.TextArea;
import java.util.Map;

public class Println implements ASTNode {

	private ASTNode data;
	private TextArea console;
	
	public Println(ASTNode data, TextArea consoleOutputComponent) {
		super();
		this.data = data;
		this.console = consoleOutputComponent;
	}

	@Override
	public Object execute(Map<String, Object> symbolTable) {
		Object msg = data.execute(symbolTable);
		if(CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			console.setText(console.getText() + msg.toString() + "\n");
		}		
		return null;
	}

}
