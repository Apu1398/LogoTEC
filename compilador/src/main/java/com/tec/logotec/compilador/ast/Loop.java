package com.tec.logotec.compilador.ast;

import java.util.List;

import com.tec.logotec.compilador.window.CompilerState;

public class Loop implements ASTNode {

	private ASTNode condition;
	private List<ASTNode> body;
	
	
	public Loop(ASTNode condition, List<ASTNode> body) {
		super();
		this.condition = condition;
		this.body = body;
	}


	
	
	@Override
	public Object execute(Context symbolTable) {
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			while((boolean)condition.execute(symbolTable)) {
				for (ASTNode statement : body) {
					statement.execute(symbolTable);
				}
			}
		}
		return null;
	}
	

}
