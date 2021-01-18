package com.tec.logotec.compilador.ast;

import java.awt.TextArea;
import java.util.List;

import com.tec.logotec.compilador.window.CompilerState;

public class Elemento implements ASTNode {

	private List<ASTNode> mathExpressions;
	private ASTNode enesimo;
	private TextArea console;
	private int line;

	public Elemento(ASTNode enesimo, List<ASTNode> mathExpressions, TextArea console, int line) {
		super();
		this.mathExpressions = mathExpressions;
		this.enesimo = enesimo;
		this.console = console;
		this.line = line;
	}
	
	
	@Override
	public Object execute(Context symbolTable) {

		if (mathExpressions.size() == 0) {
			CompilerState.errorDetected();
			console.setText("Indexout Error\n");
			return 0;

		} else {
			if (0 <= (int) enesimo.execute(symbolTable)	&& (int) enesimo.execute(symbolTable) < mathExpressions.size()) {
				return mathExpressions.get((int) enesimo.execute(symbolTable)).execute(symbolTable);
			} else {

				CompilerState.errorDetected();
				console.setText("Line " + line + ": Index Out of Range \n");
				return null;
			}
		}

	}

}
